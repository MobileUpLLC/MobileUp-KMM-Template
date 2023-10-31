package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.slot.ChildSlot
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow
import ru.flawery.core.state.CFlow
import ru.mobileup.kmm_template.core.state.CStateFlow

interface DialogControl<C : Any, T : Any> {
    val dialogSlot: CStateFlow<ChildSlot<*, T>>
    val dismissableByUser: CStateFlow<Boolean>
    val dismissedEvent: CFlow<Unit>

    fun show(config: C)
    fun dismiss()
}