package ru.mobileup.kmm_template.features.pokemons.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote

interface PokemonVotesStorage {
    val allPokemonVotes: StateFlow<List<PokemonVote>>

    fun getVoteForPokemon(pokemonName: String): Flow<Boolean?>
    fun setVoteForPokemon(pokemonVote: PokemonVote)
}