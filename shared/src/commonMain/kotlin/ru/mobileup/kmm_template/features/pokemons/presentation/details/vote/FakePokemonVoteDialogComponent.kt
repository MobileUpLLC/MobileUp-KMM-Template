package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData

class FakePokemonVoteDialogComponent : PokemonVoteDialogComponent {
    override val dialogData: CStateFlow<PokemonVoteDialogData> =
        CMutableStateFlow(PokemonVoteDialogData("", emptyList()))

    override fun votePositive() = Unit

    override fun voteNegative() = Unit

    override fun dismiss() = Unit
}