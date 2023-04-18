package ru.mobileup.kmm_template.features.flow2.ui

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.Screen2AComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2B.Screen2BComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2C.Screen2CComponent

interface Flow2Component {

    val childStack: CStateFlow<ChildStack<*, Child>>

    sealed class Child {
        class Screen2A(val component: Screen2AComponent) : Child()
        class Screen2B(val component: Screen2BComponent) : Child()
        class Screen2C(val component: Screen2CComponent) : Child()
    }

    sealed interface Output {
        object Finished : Output
    }
}