package ru.mobileup.kmm_template.features.pokemons.ui.details.vote

import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteDialogData

interface PokemonVoteDialogComponent {
    val dialogData: CStateFlow<PokemonVoteDialogData>

    fun votePositive()

    fun voteNegative()

    fun dismiss()

    @Parcelize
    data class Config(val data: PokemonVoteDialogData) : Parcelable

    sealed interface Output : Parcelable {
        @Parcelize
        data class Vote(val isPositive: Boolean) : Output
    }
}