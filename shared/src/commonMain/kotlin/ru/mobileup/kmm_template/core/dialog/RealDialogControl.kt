package ru.mobileup.kmm_template.core.dialog

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
import kotlinx.coroutines.flow.stateIn
import kotlinx.serialization.KSerializer
import ru.flawery.core.state.CFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.toCStateFlow
import ru.mobileup.kmm_template.core.utils.componentScope
import ru.mobileup.kmm_template.core.utils.toCStateFlow

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

    private val dialogNavigation = SlotNavigation<C>()

    override val dialogSlot: CStateFlow<ChildSlot<*, T>> =
        componentContext.childSlot<C, T>(
            source = dialogNavigation,
            handleBackButton = false,
            serializer = serializer,
            key = key,
            childFactory = { config: C, context: ComponentContext ->
                dialogComponentFactory(config, context, this)
            }
        ).toCStateFlow(componentContext.lifecycle)

    @OptIn(ExperimentalCoroutinesApi::class)
    override val dismissableByUser: CStateFlow<Boolean> = dialogSlot
        .flatMapLatest { slot ->
            slot.child?.let { dismissableByUser(it.configuration as C, it.instance) }
                ?: MutableStateFlow(false)
        }
        .stateIn(componentContext.componentScope, SharingStarted.Eagerly, initialValue = false)
        .toCStateFlow()

    private val _dismissedEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    override val dismissedEvent = CFlow(_dismissedEvent)

    override fun show(config: C) {
        dialogNavigation.activate(config)
    }

    override fun dismiss() {
        if (dialogSlot.value.child == null) return
        dialogNavigation.dismiss()
        _dismissedEvent.tryEmit(Unit)
    }
}