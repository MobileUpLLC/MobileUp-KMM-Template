package ru.mobileup.kmm_template.features.pokemons.domain.vote

import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.toCStateFlow
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon

class GetAllVotesForPokemonInteractor(
    private val pokemonVotesStorage: PokemonVotesStorage
) {
    fun execute(): CStateFlow<List<PokemonVote>> {
        return pokemonVotesStorage.allPokemonVotes.toCStateFlow()
    }
}