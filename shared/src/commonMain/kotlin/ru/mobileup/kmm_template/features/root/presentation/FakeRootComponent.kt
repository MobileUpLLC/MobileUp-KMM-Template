package ru.mobileup.kmm_template.features.root.presentation

import ru.mobileup.kmm_template.core.message.presentation.FakeMessageComponent
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.presentation.FakeFlow1Component

class FakeRootComponent : RootComponent {

    override val childStack = CMutableStateFlow(
        createFakeChildStack(RootComponent.Child.Flow1(FakeFlow1Component()) as RootComponent.Child)
    )

    override val messageComponent = FakeMessageComponent()
}