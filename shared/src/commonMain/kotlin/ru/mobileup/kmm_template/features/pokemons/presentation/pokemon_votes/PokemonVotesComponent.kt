package ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes

import kotlinx.coroutines.flow.StateFlow
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

interface PokemonVotesComponent {
    val pokemonVotes: StateFlow<PokemonVotes>

    @Serializable
    object Config
}