package ru.mobileup.kmm_template.core.bottom_sheet

import com.arkivanov.essenty.parcelable.Parcelable
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildSlot

class FakeBottomSheetControl<C : Parcelable, T : Any>(bottomSheetComponent: T) :
    BottomSheetControl<C, T>() {
    override val sheetOverlay = createFakeChildSlot(bottomSheetComponent)

    override val halfExpandingSupported: Boolean = true
    override val hidingSupported: Boolean = true
    override val sheetState: CStateFlow<State> = CMutableStateFlow(State.Hidden)
    override val dismissEvent: CStateFlow<Unit> = CMutableStateFlow(Unit)

    override fun shouldUpdateState(newState: State): Boolean = true
    override fun onStateChangedFromUI(state: State) = Unit
    override fun onStateChangeAnimationEnd(targetState: State) = Unit
    override fun show(config: C) = Unit
    override fun dismiss() = Unit
}