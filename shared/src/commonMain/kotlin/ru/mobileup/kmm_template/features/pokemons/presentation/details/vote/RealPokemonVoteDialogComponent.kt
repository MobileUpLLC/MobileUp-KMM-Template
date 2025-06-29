package ru.mobileup.kmm_template.features.pokemons.presentation.details.vote

import com.arkivanov.decompose.ComponentContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData

class RealPokemonVoteDialogComponent(
    componentContext: ComponentContext,
    pokemonVoteDialogData: PokemonVoteDialogData,
    private val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent>,
    private val onOutput: (PokemonVoteDialogComponent.Output) -> Unit
) : PokemonVoteDialogComponent, ComponentContext by componentContext {
    override val dialogData: StateFlow<PokemonVoteDialogData> =
        MutableStateFlow(pokemonVoteDialogData)

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