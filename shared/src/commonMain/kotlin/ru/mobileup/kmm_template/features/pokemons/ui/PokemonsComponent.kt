package ru.mobileup.kmm_template.features.pokemons.ui

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.bottom_sheet.BottomSheetControl
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.ui.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.list.PokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.PokemonVotesComponent

interface PokemonsComponent {

    val childStack: CStateFlow<ChildStack<*, Child>>

    val bottomSheetControl: BottomSheetControl<PokemonVotesComponent.Config, PokemonVotesComponent>

    fun onPokemonVotesButtonClick()

    sealed interface Child {
        class List(val component: PokemonListComponent) : Child
        class Details(val component: PokemonDetailsComponent) : Child
    }
}