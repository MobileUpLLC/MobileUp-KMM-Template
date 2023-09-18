package ru.mobileup.kmm_template.core.bottom_sheet

import com.arkivanov.decompose.router.slot.ChildSlot
import com.arkivanov.essenty.parcelable.Parcelable
import kotlinx.coroutines.flow.Flow
import ru.mobileup.kmm_template.core.state.CStateFlow

/**
 * Class to configure and control Bottom Sheet's behaviours
 */
abstract class BottomSheetControl<C : Parcelable, T : Any> {
    abstract val sheetOverlay: CStateFlow<ChildSlot<*, T>>
    abstract val sheetState: CStateFlow<State>
    abstract val halfExpandingSupported: Boolean
    abstract val hidingSupported: Boolean
    abstract val dismissEvent: Flow<Unit>

    abstract fun shouldUpdateState(newState: State): Boolean
    abstract fun onStateChangedFromUI(state: State)
    abstract fun onStateChangeAnimationEnd(targetState: State)
    abstract fun show(config: C)
    abstract fun dismiss()

    enum class State {
        Expanded, HalfExpanded, Hidden
    }
}