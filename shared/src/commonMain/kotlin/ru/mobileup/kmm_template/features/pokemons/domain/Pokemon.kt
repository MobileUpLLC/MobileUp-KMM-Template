package ru.mobileup.kmm_template.features.pokemons.domain

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize

@Parcelize
data class PokemonId(val value: String) : Parcelable

data class Pokemon(
    val id: PokemonId,
    val name: String
)