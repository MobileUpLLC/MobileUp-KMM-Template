package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.slot.ChildSlot
import kotlinx.coroutines.flow.MutableSharedFlow
import ru.flawery.core.state.CFlow
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildSlot

fun <C : Any, T : Any> fakeDialogControl(config: C, component: T): DialogControl<C, T> {
    return FakeDialogControl(config, component)
}

fun <T : Any> fakeDialogControl(component: T): DialogControl<*, T> {
    return FakeDialogControl("<fake>", component)
}

private class FakeDialogControl<C : Any, T : Any>(config: C, component: T) : DialogControl<C, T>() {

    override val dialogSlot: CStateFlow<ChildSlot<*, T>> = createFakeChildSlot(config, component)

    override val dismissedEvent: CFlow<Unit> = CFlow(MutableSharedFlow())

    override val shownEvent: CFlow<Unit> = CFlow(MutableSharedFlow())

    override val dismissableByUser: CStateFlow<Boolean> = CMutableStateFlow(true)

    override fun show(config: C) = Unit

    override fun dismiss() = Unit
}