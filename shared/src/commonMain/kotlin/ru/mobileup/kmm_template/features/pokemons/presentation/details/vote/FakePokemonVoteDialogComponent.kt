package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData

class FakePokemonVoteDialogComponent : PokemonVoteDialogComponent {
    override val dialogData: StateFlow<PokemonVoteDialogData> =
        MutableStateFlow(PokemonVoteDialogData("", emptyList()))

    override fun votePositive() = Unit

    override fun voteNegative() = Unit

    override fun dismiss() = Unit
}