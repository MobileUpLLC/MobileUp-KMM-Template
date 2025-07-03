package ru.mobileup.kmm_template.features.pokemons.presentation

import kotlinx.coroutines.flow.MutableStateFlow
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.dialog.fakeDialogControl
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.pokemons.presentation.list.FakePokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes.FakePokemonVotesComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes.PokemonVotesComponent

class FakePokemonsComponent : PokemonsComponent {

    override val childStack = MutableStateFlow(createFakeChildStack(
        PokemonsComponent.Child.List(FakePokemonListComponent()) as PokemonsComponent.Child
    )
    )

    override val bottomSheetControl: DialogControl<PokemonVotesComponent.Config, PokemonVotesComponent> =
        fakeDialogControl(PokemonVotesComponent.Config, FakePokemonVotesComponent())

    override fun onPokemonVotesButtonClick() = Unit
}