package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.slot.ChildSlot
import com.arkivanov.essenty.parcelable.Parcelable
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildSlot

class FakeDialogControl<C : Parcelable, T : Any>(dialogComponent: T) :
    DialogControl<C, T>() {
    override val dialogOverlay: CStateFlow<ChildSlot<*, T>> =
        createFakeChildSlot(dialogComponent)

    override val dismissEvent: CStateFlow<Unit> = CMutableStateFlow(Unit)

    override val canDismissed: Boolean = true

    override fun show(config: C) = Unit

    override fun dismiss() = Unit
}