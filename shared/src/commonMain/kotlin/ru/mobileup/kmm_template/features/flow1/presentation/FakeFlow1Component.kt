package ru.mobileup.kmm_template.features.flow1.presentation

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.presentation.screen1A.FakeScreen1AComponent

class FakeFlow1Component : Flow1Component {
    override val childStack = CMutableStateFlow(
        createFakeChildStack(
            Flow1Component.Child.Screen1A(FakeScreen1AComponent()) as Flow1Component.Child
        )
    )
}