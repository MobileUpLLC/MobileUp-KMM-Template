package ru.mobileup.kmm_template.features.root.ui

import ru.mobileup.kmm_template.core.message.ui.FakeMessageComponent
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.pokemons.ui.FakePokemonsComponent

class FakeRootComponent : RootComponent {

    override val childStack =
        createFakeChildStack(RootComponent.Child.Pokemons(FakePokemonsComponent()) as RootComponent.Child)

    override val messageComponent = FakeMessageComponent()
}