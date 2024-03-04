package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model

enum class PokemonVoteState {
    NONE, POSITIVE, NEGATIVE
}

fun Boolean?.toPokemonVoteState(): PokemonVoteState = when (this) {
    null -> PokemonVoteState.NONE
    true -> PokemonVoteState.POSITIVE
    false -> PokemonVoteState.NEGATIVE
}