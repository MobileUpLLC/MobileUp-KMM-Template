package ru.mobileup.kmm_template.features.pokemons.domain

data class DetailedPokemon(
    val id: PokemonId,
    val name: String,
    val height: Float,
    val weight: Float,
    val imageUrl: String,
    val types: List<PokemonType>
)