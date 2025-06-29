package ru.mobileup.kmm_template.features.flow1.presentation

import com.arkivanov.decompose.router.stack.ChildStack
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.flow1.presentation.screen1A.Screen1AComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.Screen1BComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1C.Screen1CComponent

interface Flow1Component {

    val childStack: StateFlow<ChildStack<*, Child>>

    sealed class Child {
        class Screen1A(val component: Screen1AComponent) : Child()
        class Screen1B(val component: Screen1BComponent) : Child()
        class Screen1C(val component: Screen1CComponent) : Child()
    }

    sealed interface Output {
        object Finished : Output
    }
}