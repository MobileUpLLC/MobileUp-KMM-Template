package ru.mobileup.kmm_template.features.pokemons.domain

import dev.icerock.moko.graphics.Color
import kotlinx.serialization.Serializable

@Serializable
data class PokemonTypeId(val value: String)

data class PokemonType(val id: PokemonTypeId, val name: String) {
    companion object {
        val Fire = PokemonType(id = PokemonTypeId("10"), name = "Fire")
        val Water = PokemonType(id = PokemonTypeId("11"), name = "Water")
        val Electric = PokemonType(id = PokemonTypeId("13"), name = "Electric")
        val Grass = PokemonType(id = PokemonTypeId("12"), name = "Grass")
        val Poison = PokemonType(id = PokemonTypeId("4"), name = "Poison")
    }
}

val PokemonType.color: Color
    get() = when (id.value) {
        "10" -> Color(0xFF6C6CFF) // Fire
        "11" -> Color(0x58ABF6FF) // Water
        "13" -> Color(0xF2CB55FF) // Grass
        "12" -> Color(0x8BBE8AFF) // Electric
        "4" -> Color(0x9F6E97FF) // Poison
        else -> Color(0x575757FF)
    }