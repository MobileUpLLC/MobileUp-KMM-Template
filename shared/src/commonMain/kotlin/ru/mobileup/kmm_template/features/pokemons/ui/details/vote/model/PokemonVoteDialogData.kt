package ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model

import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon

@Serializable
data class PokemonVoteDialogData(
    val pokemonName: String,
    val pokemonTypes: List<String>
) {
    val formatPokemonTypes = pokemonTypes.joinToString(separator = ", ")
}

fun DetailedPokemon.toPokemonVoteDialogData() = PokemonVoteDialogData(
    pokemonName = name,
    pokemonTypes = types.map { it.name }
)