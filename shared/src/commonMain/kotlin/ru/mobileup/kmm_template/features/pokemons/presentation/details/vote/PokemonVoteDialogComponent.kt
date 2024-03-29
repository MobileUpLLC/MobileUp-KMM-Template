package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote

import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData

interface PokemonVoteDialogComponent {
    val dialogData: CStateFlow<PokemonVoteDialogData>

    fun votePositive()

    fun voteNegative()

    fun dismiss()

    @Serializable
    data class Config(val data: PokemonVoteDialogData)

    sealed interface Output {
        @Serializable
        data class Vote(val isPositive: Boolean) : Output
    }
}