package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.slot.ChildSlot
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow

abstract class DialogControl<C : Any, T : Any> {
    abstract val dialogSlot: StateFlow<ChildSlot<*, T>>
    abstract val dismissableByUser: StateFlow<Boolean>
    abstract val dismissedEvent: Flow<Unit>
    abstract val shownEvent: Flow<Unit>

    abstract fun show(config: C)
    abstract fun dismiss()

}