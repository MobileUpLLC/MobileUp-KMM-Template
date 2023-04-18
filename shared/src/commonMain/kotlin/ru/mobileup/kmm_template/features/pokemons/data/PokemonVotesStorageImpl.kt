package ru.mobileup.kmm_template.features.pokemons.data

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

class PokemonVotesStorageImpl : PokemonVotesStorage {
    override val allPokemonVotes = MutableStateFlow(PokemonVotes(emptyList()))

    override fun getVoteForPokemon(pokemonName: String): Flow<Boolean?> {
        return allPokemonVotes.map { votes -> votes.votes.find { it.pokemonName == pokemonName }?.isPositive }
    }

    override fun setVoteForPokemon(pokemonVote: PokemonVote) {
        allPokemonVotes.value =
            allPokemonVotes.value.copy(votes = allPokemonVotes.value.votes + pokemonVote)
    }
}