package ru.mobileup.kmm_template.features.root.presentation

import com.arkivanov.decompose.router.stack.ChildStack
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.message.presentation.MessageComponent
import ru.mobileup.kmm_template.features.flow1.presentation.Flow1Component
import ru.mobileup.kmm_template.features.flow2.presentation.Flow2Component
import ru.mobileup.kmm_template.features.home.HomeComponent

/**
 * A root of a Decompose component tree.
 *
 * Note: Try to minimize child count in RootComponent. It should operate by flows of screens rather than separate screens.
 */
interface RootComponent {

    val childStack: StateFlow<ChildStack<*, Child>>

    val messageComponent: MessageComponent

    sealed class Child {
        class Flow1(val component: Flow1Component) : Child()
        class Home(val component: HomeComponent) : Child()
        class Flow2(val component: Flow2Component) : Child()
    }
}