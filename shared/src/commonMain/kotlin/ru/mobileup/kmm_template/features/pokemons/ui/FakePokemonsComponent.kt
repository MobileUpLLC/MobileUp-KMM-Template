package ru.mobileup.kmm_template.features.pokemons.ui

import ru.mobileup.kmm_template.core.bottom_sheet.BottomSheetControl
import ru.mobileup.kmm_template.core.bottom_sheet.FakeBottomSheetControl
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.pokemons.ui.list.FakePokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.FakePokemonVotesComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.PokemonVotesComponent

class FakePokemonsComponent : PokemonsComponent {

    override val childStack = createFakeChildStack(
        PokemonsComponent.Child.List(FakePokemonListComponent()) as PokemonsComponent.Child
    )

    override val bottomSheetControl: BottomSheetControl<PokemonVotesComponent.Config, PokemonVotesComponent> =
        FakeBottomSheetControl(FakePokemonVotesComponent())

    override fun onPokemonVotesButtonClick() = Unit
}