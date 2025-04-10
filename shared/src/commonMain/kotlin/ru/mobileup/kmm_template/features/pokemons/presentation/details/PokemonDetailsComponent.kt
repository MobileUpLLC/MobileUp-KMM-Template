package ru.mobileup.kmm_template.features.pokemons.presentation.details

import dev.icerock.moko.graphics.Color
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteState

interface PokemonDetailsComponent {

    val pokemonVoteState: StateFlow<PokemonVoteState>

    val title: StringDesc

    val pokemonState: StateFlow<LoadableState<DetailedPokemon>>

    val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent>

    fun onVoteClick()

    fun onRetryClick()

    fun onRefresh()

    fun getPokemonColor(type: PokemonType): Color
}