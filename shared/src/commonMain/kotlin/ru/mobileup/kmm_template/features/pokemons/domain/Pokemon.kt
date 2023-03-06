package ru.mobileup.kmm_template.features.pokemons.domain

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import kotlin.jvm.JvmInline

@Parcelize
@JvmInline
value class PokemonId(val value: String) : Parcelable

data class Pokemon(
    val id: PokemonId,
    val name: String
)