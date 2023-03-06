package ru.mobileup.kmm_template.features.pokemons.ui

import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.pokemons.ui.list.FakePokemonListComponent

class FakePokemonsComponent : PokemonsComponent {

    override val childStack = createFakeChildStack(
        PokemonsComponent.Child.List(FakePokemonListComponent()) as PokemonsComponent.Child
    )
}