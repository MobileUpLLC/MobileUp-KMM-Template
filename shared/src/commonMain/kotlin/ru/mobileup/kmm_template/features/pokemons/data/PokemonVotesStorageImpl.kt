package ru.mobileup.kmm_template.features.pokemons.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

class PokemonVotesStorageImpl : PokemonVotesStorage {
    override val allPokemonVotes = MutableStateFlow(emptyMap<String, Boolean>())

    override fun getVoteForPokemon(pokemonName: String): Flow<Boolean?> {
        return allPokemonVotes.map { it[pokemonName] }
    }

    override fun setVoteForPokemon(pokemonName: String, vote: Boolean) {
        allPokemonVotes.value = allPokemonVotes.value + (pokemonName to vote)
    }
}