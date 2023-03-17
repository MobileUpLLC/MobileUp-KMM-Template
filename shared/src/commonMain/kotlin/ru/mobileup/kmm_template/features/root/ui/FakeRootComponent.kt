package ru.mobileup.kmm_template.features.root.ui

import ru.mobileup.kmm_template.core.message.ui.FakeMessageComponent
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.flow1.ui.FakeFlow1Component

class FakeRootComponent : RootComponent {

    override val childStack =
        createFakeChildStack(RootComponent.Child.Flow1(FakeFlow1Component()) as RootComponent.Child)

    override val messageComponent = FakeMessageComponent()
}