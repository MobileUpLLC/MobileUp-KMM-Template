package ru.mobileup.kmm_template.features.pokemons.domain

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import kotlin.jvm.JvmInline

@Parcelize
@JvmInline
value class PokemonTypeId(val value: String) : Parcelable

data class PokemonType(val id: PokemonTypeId, val name: String) {
    companion object {
        val Fire = PokemonType(id = PokemonTypeId("10"), name = "Fire")
        val Water = PokemonType(id = PokemonTypeId("11"), name = "Water")
        val Electric = PokemonType(id = PokemonTypeId("13"), name = "Electric")
        val Grass = PokemonType(id = PokemonTypeId("12"), name = "Grass")
        val Poison = PokemonType(id = PokemonTypeId("4"), name = "Poison")
    }
}