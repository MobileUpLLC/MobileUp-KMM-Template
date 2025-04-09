package ru.mobileup.kmm_template.features.pokemons.presentation

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.presentation.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.list.PokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes.PokemonVotesComponent

interface PokemonsComponent {

    val childStack: CStateFlow<ChildStack<*, Child>>

    val bottomSheetControl: DialogControl<PokemonVotesComponent.Config, PokemonVotesComponent>

    fun onPokemonVotesButtonClick()

    sealed class Child {
        class List(val component: PokemonListComponent) : Child()
        class Details(val component: PokemonDetailsComponent) : Child()
    }
}