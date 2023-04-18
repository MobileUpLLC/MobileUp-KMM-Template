package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.overlay.*
import com.arkivanov.essenty.parcelable.Parcelable
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import kotlin.reflect.KClass

private const val DIALOG_CHILD_OVERLAY_KEY = "dialogChildOverlay"

inline fun <reified C : Parcelable, T : Any> ComponentContext.dialogControl(
    noinline dialogComponentFactory: (C, ComponentContext, DialogControl<C, T>) -> T,
    key: String? = null,
    handleBackButton: Boolean = false,
    canDismissed: Boolean = true
): DialogControl<C, T> {
    return dialogControl(
        dialogComponentFactory,
        key,
        handleBackButton,
        C::class,
        canDismissed
    )
}

fun <C : Parcelable, T : Any> ComponentContext.dialogControl(
    dialogComponentFactory: (C, ComponentContext, DialogControl<C, T>) -> T,
    key: String? = null,
    handleBackButton: Boolean = false,
    clazz: KClass<C>,
    canDismissed: Boolean = true
): DialogControl<C, T> = RealDialogControl(
    this,
    dialogComponentFactory,
    key ?: DIALOG_CHILD_OVERLAY_KEY,
    handleBackButton,
    clazz,
    canDismissed
)

private class RealDialogControl<C : Parcelable, T : Any>(
    componentContext: ComponentContext,
    private val dialogComponentFactory: (C, ComponentContext, DialogControl<C, T>) -> T,
    key: String,
    handleBackButton: Boolean,
    clazz: KClass<C>,
    override val canDismissed: Boolean
) : DialogControl<C, T>() {

    private val dialogNavigation = OverlayNavigation<C>()

    override val dismissEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    override val dialogOverlay: CStateFlow<ChildOverlay<*, T>> =
        componentContext.childOverlay(
            source = dialogNavigation,
            handleBackButton = handleBackButton,
            key = key,
            configurationClass = clazz,
            childFactory = { configuration, context ->
                dialogComponentFactory(configuration, context, this)
            }
        ).toCStateFlow(componentContext.lifecycle)


    override fun show(config: C) {
        dialogNavigation.activate(config)
    }

    override fun dismiss() {
        dialogNavigation.dismiss()
        dismissEvent.tryEmit(Unit)
    }
}