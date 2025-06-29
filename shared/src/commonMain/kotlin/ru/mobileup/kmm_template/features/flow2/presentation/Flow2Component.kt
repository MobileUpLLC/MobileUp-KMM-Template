package ru.mobileup.kmm_template.features.flow2.presentation

import com.arkivanov.decompose.router.stack.ChildStack
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.flow2.presentation.screen2A.Screen2AComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2B.Screen2BComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2C.Screen2CComponent

interface Flow2Component {

    val childStack: StateFlow<ChildStack<*, Child>>

    sealed class Child {
        class Screen2A(val component: Screen2AComponent) : Child()
        class Screen2B(val component: Screen2BComponent) : Child()
        class Screen2C(val component: Screen2CComponent) : Child()
    }

    sealed interface Output {
        object Finished : Output
    }
}