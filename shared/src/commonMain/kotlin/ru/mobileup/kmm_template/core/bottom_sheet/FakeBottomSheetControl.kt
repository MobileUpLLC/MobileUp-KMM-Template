package ru.mobileup.kmm_template.core.bottom_sheet

import com.arkivanov.decompose.router.overlay.ChildOverlay
import com.arkivanov.essenty.parcelable.Parcelable
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildOverlay

class FakeBottomSheetControl<C : Parcelable, T : Any>(bottomSheetComponent: T) :
    BottomSheetControl<C, T>() {
    override val sheetOverlay: CStateFlow<ChildOverlay<*, T>> =
        createFakeChildOverlay(bottomSheetComponent)

    override val sheetState: CStateFlow<BottomSheetControl.State> =
        CMutableStateFlow(BottomSheetControl.State.Hidden)
    override val halfExpandingSupported: Boolean = true
    override val hidingSupported: Boolean = true
    override val dismissEvent: CStateFlow<Unit> = CMutableStateFlow(Unit)

    override fun onStateChanged(state: BottomSheetControl.State) = true

    override fun show(config: C) = Unit

    override fun dismiss() = Unit
}