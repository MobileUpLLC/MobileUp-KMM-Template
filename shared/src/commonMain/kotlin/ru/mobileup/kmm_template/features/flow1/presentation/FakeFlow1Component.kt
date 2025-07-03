package ru.mobileup.kmm_template.features.flow1.presentation

import kotlinx.coroutines.flow.MutableStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.presentation.screen1A.FakeScreen1AComponent

class FakeFlow1Component : Flow1Component {
    override val childStack = MutableStateFlow(
        createFakeChildStack(
            Flow1Component.Child.Screen1A(FakeScreen1AComponent()) as Flow1Component.Child
        )
    )
}