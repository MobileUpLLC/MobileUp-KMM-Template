package ru.mobileup.kmm_template.features.flow2.presentation

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow2.presentation.screen2A.FakeScreen2AComponent

class FakeFlow2Component : Flow2Component {
    override val childStack = CMutableStateFlow(
        createFakeChildStack(
            Flow2Component.Child.Screen2A(FakeScreen2AComponent()) as Flow2Component.Child
        )
    )
}