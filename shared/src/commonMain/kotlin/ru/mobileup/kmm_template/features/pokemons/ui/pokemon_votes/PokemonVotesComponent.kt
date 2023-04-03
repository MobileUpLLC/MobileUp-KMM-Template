package ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote

interface PokemonVotesComponent {
    val pokemonVotes: CStateFlow<List<PokemonVote>>

    @Parcelize
    object Config : Parcelable
}