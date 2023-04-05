package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.router.overlay.ChildOverlay
import com.arkivanov.essenty.parcelable.Parcelable
import kotlinx.coroutines.flow.Flow
import ru.mobileup.kmm_template.core.state.CStateFlow

/**
 * Class to configure and control dialog's behaviours
 */
interface DialogControl<C : Parcelable, T : Any> {
    val dialogOverlay: CStateFlow<ChildOverlay<*, T>>
    val dismissEvent: Flow<Unit>
    val canDismissed: Boolean

    fun show(config: C)
    fun dismiss()
}