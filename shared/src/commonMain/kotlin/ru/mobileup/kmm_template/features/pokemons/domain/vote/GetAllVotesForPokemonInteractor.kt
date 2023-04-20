package ru.mobileup.kmm_template.features.pokemons.domain.vote

import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.toCStateFlow
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage

class GetAllVotesForPokemonInteractor(
    private val pokemonVotesStorage: PokemonVotesStorage
) {
    fun execute(): CStateFlow<ListWrapper<PokemonVote>> {
        return pokemonVotesStorage.allPokemonVotes.toCStateFlow()
    }
}