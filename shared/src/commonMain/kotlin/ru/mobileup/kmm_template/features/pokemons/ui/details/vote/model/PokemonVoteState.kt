package ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model

import co.touchlab.skie.configuration.annotations.EnumInterop

@EnumInterop.Enabled
enum class PokemonVoteState {
    NONE, POSITIVE, NEGATIVE
}

fun Boolean?.toPokemonVoteState(): PokemonVoteState = when (this) {
    null -> PokemonVoteState.NONE
    true -> PokemonVoteState.POSITIVE
    false -> PokemonVoteState.NEGATIVE
}