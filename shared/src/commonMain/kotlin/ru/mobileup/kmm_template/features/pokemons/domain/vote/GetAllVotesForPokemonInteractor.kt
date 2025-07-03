package ru.mobileup.kmm_template.features.pokemons.domain.vote

import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage

class GetAllVotesForPokemonInteractor(
    private val pokemonVotesStorage: PokemonVotesStorage
) {
    fun execute(): StateFlow<PokemonVotes> {
        return pokemonVotesStorage.allPokemonVotes
    }
}