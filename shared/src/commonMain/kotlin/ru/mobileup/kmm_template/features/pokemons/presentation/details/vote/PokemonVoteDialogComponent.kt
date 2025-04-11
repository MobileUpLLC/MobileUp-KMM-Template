package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote

import kotlinx.coroutines.flow.StateFlow
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData

interface PokemonVoteDialogComponent {
    val dialogData: StateFlow<PokemonVoteDialogData>

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