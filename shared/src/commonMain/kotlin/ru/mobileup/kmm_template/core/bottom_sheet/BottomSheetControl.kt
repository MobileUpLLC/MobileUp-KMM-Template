package ru.mobileup.kmm_template.core.bottom_sheet

import com.arkivanov.decompose.router.overlay.ChildOverlay
import com.arkivanov.essenty.parcelable.Parcelable
import kotlinx.coroutines.flow.Flow
import ru.mobileup.kmm_template.core.state.CStateFlow

/**
 * Class to configure and control Bottom Sheet's behaviours
 */
interface BottomSheetControl<C : Parcelable, T : Any> {
    val sheetOverlay: CStateFlow<ChildOverlay<*, T>>
    val sheetState: CStateFlow<State>
    val halfExpandingSupported: Boolean
    val hidingSupported: Boolean
    val dismissEvent: Flow<Unit>

    fun onStateChanged(state: State): Boolean
    fun show(config: C)
    fun dismiss()

    enum class State {
        Expanded, HalfExpanded, Hidden
    }
}