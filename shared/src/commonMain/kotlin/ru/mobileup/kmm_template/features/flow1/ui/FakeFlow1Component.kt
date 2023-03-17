package ru.mobileup.kmm_template.features.flow1.ui

import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.FakeScreen1AComponent

class FakeFlow1Component : Flow1Component {
    override val childStack = createFakeChildStack(
        Flow1Component.Child.Screen1A(FakeScreen1AComponent()) as Flow1Component.Child
    )
}