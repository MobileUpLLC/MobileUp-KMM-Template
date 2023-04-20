package ru.mobileup.kmm_template.features.pokemons.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import ru.mobileup.kmm_template.features.pokemons.domain.vote.ListWrapper
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote

class PokemonVotesStorageImpl : PokemonVotesStorage {
    override val allPokemonVotes = MutableStateFlow(ListWrapper(emptyList<PokemonVote>()))

    override fun getVoteForPokemon(pokemonName: String): Flow<Boolean?> {
        return allPokemonVotes.map { votes -> votes.list.find { it.pokemonName == pokemonName }?.isPositive }
    }

    override fun setVoteForPokemon(pokemonVote: PokemonVote) {
        allPokemonVotes.value =
            allPokemonVotes.value.copy(list = allPokemonVotes.value.list + pokemonVote)
    }
}