package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.slot.ChildSlot
import ru.flawery.core.state.CFlow
import ru.mobileup.kmm_template.core.state.CStateFlow

abstract class DialogControl<C : Any, T : Any> {
    abstract val dialogSlot: CStateFlow<ChildSlot<*, T>>
    abstract val dismissableByUser: CStateFlow<Boolean>
    abstract val dismissedEvent: CFlow<Unit>

    abstract fun show(config: C)
    abstract fun dismiss()
}