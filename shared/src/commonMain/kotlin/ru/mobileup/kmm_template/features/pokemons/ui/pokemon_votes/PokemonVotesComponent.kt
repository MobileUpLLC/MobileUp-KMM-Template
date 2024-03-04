package ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes

import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

interface PokemonVotesComponent {
    val pokemonVotes: CStateFlow<PokemonVotes>

    @Serializable
    object Config
}