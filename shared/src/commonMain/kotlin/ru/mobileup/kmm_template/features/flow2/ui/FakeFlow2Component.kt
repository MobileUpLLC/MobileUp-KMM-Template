package ru.mobileup.kmm_template.features.flow2.ui

import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.FakeScreen2AComponent

class FakeFlow2Component : Flow2Component {
    override val childStack = createFakeChildStack(
        Flow2Component.Child.Screen2A(FakeScreen2AComponent()) as Flow2Component.Child
    )
}