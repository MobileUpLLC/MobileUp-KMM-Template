package ru.mobileup.kmm_template.features.pokemons.domain.vote

data class ListWrapper<T : Any>(
    val list: List<T>
)

data class PokemonVote(
    val pokemonName: String,
    val isPositive: Boolean?
)
