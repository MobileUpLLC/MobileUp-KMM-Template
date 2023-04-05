package ru.mobileup.kmm_template.core.bottom_sheet

import co.touchlab.kermit.Logger
import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.overlay.*
import com.arkivanov.essenty.parcelable.Parcelable
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import kotlin.reflect.KClass

private const val SHEET_CHILD_OVERLAY_KEY = "sheetChildOverlay"

inline fun <reified C : Parcelable, T : Any> ComponentContext.bottomSheetControl(
    noinline bottomSheetComponentFactory: (C, ComponentContext, BottomSheetControl<C, T>) -> T,
    key: String? = null,
    halfExpandingSupported: Boolean,
    hidingSupported: Boolean,
    handleBackButton: Boolean = false,
): BottomSheetControl<C, T> {
    return bottomSheetControl(
        bottomSheetComponentFactory,
        key,
        halfExpandingSupported,
        hidingSupported,
        handleBackButton,
        C::class
    )
}

fun <C : Parcelable, T : Any> ComponentContext.bottomSheetControl(
    bottomSheetComponentFactory: (C, ComponentContext, BottomSheetControl<C, T>) -> T,
    key: String? = null,
    halfExpandingSupported: Boolean,
    hidingSupported: Boolean,
    handleBackButton: Boolean = false,
    clazz: KClass<C>,
): BottomSheetControl<C, T> = RealBottomSheetControl(
    this,
    bottomSheetComponentFactory,
    key ?: SHEET_CHILD_OVERLAY_KEY,
    halfExpandingSupported,
    hidingSupported,
    handleBackButton,
    clazz,
)

private class RealBottomSheetControl<C : Parcelable, T : Any>(
    componentContext: ComponentContext,
    private val bottomSheetComponentFactory: (C, ComponentContext, BottomSheetControl<C, T>) -> T,
    key: String,
    override val halfExpandingSupported: Boolean,
    override val hidingSupported: Boolean,
    handleBackButton: Boolean,
    clazz: KClass<C>,
) : BottomSheetControl<C, T> {

    private val logger = Logger.withTag("BottomSheetControl")

    private val sheetNavigation = OverlayNavigation<C>()

    override val sheetState = CMutableStateFlow(BottomSheetControl.State.Hidden)

    override val dismissEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    override val sheetOverlay: CStateFlow<ChildOverlay<*, T>> =
        componentContext.childOverlay(
            source = sheetNavigation,
            handleBackButton = handleBackButton,
            key = key,
            configurationClass = clazz,
            childFactory = { configuration, context ->
                bottomSheetComponentFactory(configuration, context, this)
            }
        ).toCStateFlow(componentContext.lifecycle)

    override fun onStateChanged(state: BottomSheetControl.State): Boolean {
        if (sheetOverlay.value.overlay?.instance == null) {
            logger.w("BottomSheetControl: instance is null")
            return false
        }

        val shouldUpdate = shouldUpdateState(state)
        if (shouldUpdate) {
            sheetState.value = state
            if (state == BottomSheetControl.State.Hidden) dismiss()
        }
        return shouldUpdate
    }

    override fun show(config: C) {
        sheetNavigation.activate(config)
        sheetState.value = BottomSheetControl.State.Expanded
    }

    override fun dismiss() {
        sheetState.value = BottomSheetControl.State.Hidden
        sheetNavigation.dismiss()
        dismissEvent.tryEmit(Unit)
    }

    private fun shouldUpdateState(newState: BottomSheetControl.State) = when (newState) {
        BottomSheetControl.State.Expanded -> true
        BottomSheetControl.State.HalfExpanded -> halfExpandingSupported
        BottomSheetControl.State.Hidden -> hidingSupported
    }
}