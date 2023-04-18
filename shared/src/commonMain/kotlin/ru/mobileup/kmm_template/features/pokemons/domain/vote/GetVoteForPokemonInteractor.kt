package ru.mobileup.kmm_template.features.pokemons.domain.vote

import kotlinx.coroutines.flow.Flow
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage

class GetVoteForPokemonInteractor(
    private val pokemonVotesStorage: PokemonVotesStorage
) {
    fun execute(pokemonName: String): Flow<Boolean?> {
        return pokemonVotesStorage.getVoteForPokemon(pokemonName)
    }
}