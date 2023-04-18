package ru.mobileup.kmm_template.features.pokemons.domain.vote

import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage

class SetVoteForPokemonInteractor(
    private val pokemonVotesStorage: PokemonVotesStorage
) {
    fun execute(pokemonVote: PokemonVote) {
        pokemonVotesStorage.setVoteForPokemon(pokemonVote)
    }
}