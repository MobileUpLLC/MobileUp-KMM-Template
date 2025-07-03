package ru.mobileup.kmm_template.core.dialog

import co.touchlab.kermit.Logger
import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.slot.ChildSlot
import com.arkivanov.decompose.router.slot.SlotNavigation
import com.arkivanov.decompose.router.slot.activate
import com.arkivanov.decompose.router.slot.childSlot
import com.arkivanov.decompose.router.slot.dismiss
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.stateIn
import kotlinx.serialization.KSerializer
import ru.mobileup.kmm_template.core.utils.componentScope
import ru.mobileup.kmm_template.core.utils.toStateFlow

fun <C : Any, T : Any> ComponentContext.dialogControl(
    key: String,
    dialogComponentFactory: (C, ComponentContext, DialogControl<C, T>) -> T,
    dismissableByUser: (C, T) -> StateFlow<Boolean> = { _, _ -> MutableStateFlow(true) },
    serializer: KSerializer<C>? = null,
): DialogControl<C, T> {
    return RealDialogControl(
        componentContext = this,
        dialogComponentFactory = dialogComponentFactory,
        key = key,
        dismissableByUser = dismissableByUser,
        serializer = serializer
    )
}

private class RealDialogControl<C : Any, T : Any>(
    componentContext: ComponentContext,
    key: String,
    private val dialogComponentFactory: (C, ComponentContext, DialogControl<C, T>) -> T,
    dismissableByUser: (C, T) -> StateFlow<Boolean>,
    serializer: KSerializer<C>?
) : DialogControl<C, T>() {

    private val logger = Logger.withTag("DialogControl")

    private val dialogNavigation = SlotNavigation<C>()

    override val dialogSlot: StateFlow<ChildSlot<*, T>> =
        componentContext.childSlot<ComponentContext, C, T>(
            source = dialogNavigation,
            handleBackButton = false,
            serializer = serializer,
            key = key,
            childFactory = { config: C, context: ComponentContext ->
                dialogComponentFactory(config, context, this)
            }
        ).toStateFlow(componentContext.lifecycle)

    @OptIn(ExperimentalCoroutinesApi::class)
    override val dismissableByUser: StateFlow<Boolean> = dialogSlot
        .flatMapLatest { slot ->
            slot.child?.let { dismissableByUser(it.configuration as C, it.instance) }
                ?: MutableStateFlow(false)
        }
        .stateIn(componentContext.componentScope, SharingStarted.Eagerly, initialValue = false)

    override val dismissedEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    override val shownEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    private var savedConfig: C? = null

    init {
        val (activateFlow, deactivateFlow) = componentContext
            .activeDialogManager
            .registerDialog(key, this)

        activateFlow
            .onEach {
                savedConfig?.let {
                    logger.i("load saved configuration and show: $it")
                    dialogNavigation.activate(it)
                    savedConfig = null
                }
            }
            .launchIn(componentContext.componentScope)

        deactivateFlow
            .onEach {
                (dialogSlot.value.child?.configuration as? C)?.let {
                    logger.i("saving configuration and dismiss: $it")
                    savedConfig = it
                    dialogNavigation.dismiss()
                }
            }
            .launchIn(componentContext.componentScope)
    }

    override fun show(config: C) {
        if (dialogSlot.value.child?.configuration == config || savedConfig == config) return
        // отправляем ивент раньше активации специально, чтобы на iOS
        // сначала скрылся старый боттомшит, затем открылся новый, иначе новый не откроется
        // см. ActiveDialogManager
        shownEvent.tryEmit(Unit)
        dialogNavigation.activate(config)
    }

    override fun dismiss() {
        if (dialogSlot.value.child == null && savedConfig == null) return
        savedConfig = null
        dialogNavigation.dismiss()
        dismissedEvent.tryEmit(Unit)
    }
}
