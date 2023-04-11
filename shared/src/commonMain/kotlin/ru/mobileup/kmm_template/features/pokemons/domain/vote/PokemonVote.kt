package ru.mobileup.kmm_template.features.pokemons.domain.vote

data class PokemonVotes(
    val votes: List<PokemonVote>
)

data class PokemonVote(
    val pokemonName: String,
    val isPositive: Boolean?
)
