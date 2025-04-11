package ru.mobileup.kmm_template.features.flow2.presentation

import kotlinx.coroutines.flow.MutableStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow2.presentation.screen2A.FakeScreen2AComponent

class FakeFlow2Component : Flow2Component {
    override val childStack = MutableStateFlow(
        createFakeChildStack(
            Flow2Component.Child.Screen2A(FakeScreen2AComponent()) as Flow2Component.Child
        )
    )
}