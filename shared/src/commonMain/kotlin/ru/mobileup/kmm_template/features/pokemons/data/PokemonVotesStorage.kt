package ru.mobileup.kmm_template.features.pokemons.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow

interface PokemonVotesStorage {
    val allPokemonVotes: StateFlow<Map<String, Boolean>>

    fun getVoteForPokemon(pokemonName: String): Flow<Boolean?>
    fun setVoteForPokemon(pokemonName: String, vote: Boolean)
}