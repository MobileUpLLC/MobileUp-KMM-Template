package ru.mobileup.kmm_template.features.pokemons.ui.details.vote

import com.arkivanov.decompose.ComponentContext
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteDialogData

class RealPokemonVoteDialogComponent(
    componentContext: ComponentContext,
    pokemonVoteDialogData: PokemonVoteDialogData,
    private val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent>,
    private val onOutput: (PokemonVoteDialogComponent.Output) -> Unit
) : PokemonVoteDialogComponent, ComponentContext by componentContext {
    override val dialogData: CStateFlow<PokemonVoteDialogData> =
        CMutableStateFlow(pokemonVoteDialogData)

    override fun votePositive() {
        onOutput(PokemonVoteDialogComponent.Output.Vote(isPositive = true))
    }

    override fun voteNegative() {
        onOutput(PokemonVoteDialogComponent.Output.Vote(isPositive = false))
    }

    override fun dismiss() {
        dialogControl.dismiss()
    }
}