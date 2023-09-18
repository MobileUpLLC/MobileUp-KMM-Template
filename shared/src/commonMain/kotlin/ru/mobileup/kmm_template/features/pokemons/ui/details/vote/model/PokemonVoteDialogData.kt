package ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon

@Parcelize
data class PokemonVoteDialogData(
    val pokemonName: String,
    val pokemonTypes: List<String>
) : Parcelable {
    val formatPokemonTypes = pokemonTypes.joinToString(separator = ", ")
}

fun DetailedPokemon.toPokemonVoteDialogData() = PokemonVoteDialogData(
    pokemonName = name,
    pokemonTypes = types.map { it.name }
)