package ru.mobileup.kmm_template.features.root.presentation

import kotlinx.coroutines.flow.MutableStateFlow
import ru.mobileup.kmm_template.core.message.presentation.FakeMessageComponent
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.presentation.FakeFlow1Component

class FakeRootComponent : RootComponent {

    override val childStack = MutableStateFlow(
        createFakeChildStack(RootComponent.Child.Flow1(FakeFlow1Component()) as RootComponent.Child)
    )

    override val messageComponent = FakeMessageComponent()
}