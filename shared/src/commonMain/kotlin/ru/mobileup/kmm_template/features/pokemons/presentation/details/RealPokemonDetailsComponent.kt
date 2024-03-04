package ru.mobileup.kmm_template.features.pokemons.presentation.details

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import me.aartikov.replica.single.Replica
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.dialog.dialogControl
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.computed
import ru.mobileup.kmm_template.core.state.toCNullableStateFlow
import ru.mobileup.kmm_template.core.utils.componentScope
import ru.mobileup.kmm_template.core.utils.observe
import ru.mobileup.kmm_template.features.pokemons.createPokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.vote.GetVoteForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote
import ru.mobileup.kmm_template.features.pokemons.domain.vote.SetVoteForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteState
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.toPokemonVoteDialogData
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.toPokemonVoteState

class RealPokemonDetailsComponent(
    componentContext: ComponentContext,
    private val pokemonName: String,
    private val pokemonReplica: Replica<DetailedPokemon>,
    private val setVoteForPokemonInteractor: SetVoteForPokemonInteractor,
    getVoteForPokemonInteractor: GetVoteForPokemonInteractor,
    private val componentFactory: ComponentFactory,
    errorHandler: ErrorHandler
) : ComponentContext by componentContext, PokemonDetailsComponent {

    private val pokemonVote = getVoteForPokemonInteractor.execute(pokemonName)
        .stateIn(componentScope, SharingStarted.Eagerly, null)
        .toCNullableStateFlow()

    override val pokemonVoteState: CStateFlow<PokemonVoteState> = computed(pokemonVote) {
        it.toPokemonVoteState()
    }

    override val title: StringDesc get() = StringDesc.Raw(pokemonName)

    override val pokemonState = pokemonReplica.observe(this, errorHandler)

    override val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent> =
        dialogControl(
            key = "dialogControl",
            dialogComponentFactory = ::createPokemonVoteDialogComponent
        )

    override fun onVoteClick() {
        pokemonState.value.data?.let { detailedPokemon ->
            val dialogData = detailedPokemon.toPokemonVoteDialogData()
            val config = PokemonVoteDialogComponent.Config(dialogData)
            dialogControl.show(config)
        }
    }

    override fun onRetryClick() {
        pokemonReplica.refresh()
    }

    override fun onRefresh() {
        pokemonReplica.refresh()
    }

    private fun createPokemonVoteDialogComponent(
        config: PokemonVoteDialogComponent.Config,
        context: ComponentContext,
        control: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent>
    ): PokemonVoteDialogComponent {
        return componentFactory.createPokemonVoteDialogComponent(
            context,
            config.data,
            control,
            ::onVoteOutput
        )
    }

    private fun onVoteOutput(output: PokemonVoteDialogComponent.Output) {
        when (output) {
            is PokemonVoteDialogComponent.Output.Vote -> {
                val pokemonVote = PokemonVote(pokemonName, output.isPositive)
                setVoteForPokemonInteractor.execute(pokemonVote)
                dialogControl.dismiss()
            }
        }
    }
}