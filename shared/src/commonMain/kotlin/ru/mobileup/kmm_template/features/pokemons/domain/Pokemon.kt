package ru.mobileup.kmm_template.features.pokemons.domain

import kotlinx.serialization.Serializable

@Serializable
data class PokemonId(val value: String)

data class Pokemon(
    val id: PokemonId,
    val name: String
)