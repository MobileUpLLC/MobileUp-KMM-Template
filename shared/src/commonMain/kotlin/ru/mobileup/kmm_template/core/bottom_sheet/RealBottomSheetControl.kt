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

/**
 * Если в одном компоненте подразумевается использоваение более одного ботомшита/диалога
 * то каждому из них должен быть присвоен уникальный строковый ключ-идентификатор.
 * Иначе приложение упадет с ошибкой (Another supplier is already registered with the key)
 * Это особенность реализации childOverlay в библиотеку decompose
 */
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
) : BottomSheetControl<C, T>() {

    private val logger = Logger.withTag("BottomSheetControl")

    private val sheetNavigation = OverlayNavigation<C>()

    override val sheetState = CMutableStateFlow(State.Hidden)

    override val dismissEvent = MutableSharedFlow<Unit>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    /**
     * child overlay это один из типов навигации в decompose, у него может быть только один instance
     * Когда надо показать bottom sheet мы добавляем в него компонент боттом шита,
     * когда он закрывается его удаляем. Можно для каждого боттом шита использовать отдельный
     * компонент, можно сделать какой-то общий компонент и передавать его
     *
     * https://arkivanov.github.io/Decompose/navigation/slot/overview/
     * D либе Decompose переименовали child overlay в child slot
     */
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

    override fun onStateChangedFromUI(state: State) {
        if (sheetOverlay.value.overlay?.instance == null) {
            logger.w("BottomSheetControl: instance is null")
            sheetState.value = State.Hidden
            return
        }

        sheetState.value = state
    }

    override fun onStateChangeAnimationEnd(targetState: State) {
        if (targetState == State.Hidden) {
            sheetNavigation.dismiss()
            dismissEvent.tryEmit(Unit)
        }
    }

    override fun show(config: C) {
        sheetNavigation.activate(config)
        sheetState.value = State.Expanded
    }

    override fun dismiss() {
        sheetState.value = State.Hidden
        sheetNavigation.dismiss()
        dismissEvent.tryEmit(Unit)
    }

    /**
     * в shouldUpdateState мы делаем проверку, может ли bottom sheet перейти в это состояние.
     * например проверка флага hiddenSupported
     */
    override fun shouldUpdateState(newState: State) = when (newState) {
        State.Expanded -> true
        State.HalfExpanded -> halfExpandingSupported
        State.Hidden -> hidingSupported
    }
}