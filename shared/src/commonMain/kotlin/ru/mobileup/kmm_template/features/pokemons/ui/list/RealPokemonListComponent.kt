package ru.mobileup.kmm_template.features.pokemons.ui.list

import com.arkivanov.decompose.ComponentContext
import kotlinx.serialization.Serializable
import me.aartikov.replica.algebra.normal.withKey
import me.aartikov.replica.keyed.KeyedReplica
import me.aartikov.replica.keyed.keepPreviousData
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.observe
import ru.mobileup.kmm_template.core.utils.persistent
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId

class RealPokemonListComponent(
    componentContext: ComponentContext,
    private val onOutput: (PokemonListComponent.Output) -> Unit,
    private val pokemonsByTypeReplica: KeyedReplica<PokemonTypeId, List<Pokemon>>,
    errorHandler: ErrorHandler
) : ComponentContext by componentContext, PokemonListComponent {

    override val types = CMutableStateFlow(
        listOf(
            PokemonType.Fire,
            PokemonType.Water,
            PokemonType.Electric,
            PokemonType.Grass,
            PokemonType.Poison
        )
    )

    override var selectedTypeId = CMutableStateFlow(types.value[0].id)
        private set

    override val pokemonsState = pokemonsByTypeReplica
        .keepPreviousData()
        .withKey(selectedTypeId)
        .observe(this, errorHandler)

    init {
        persistent(
            save = { PersistentState(selectedTypeId.value) },
            restore = { state -> selectedTypeId.value = state.selectedTypeId },
            serializer = PersistentState.serializer()
        )
    }

    override fun onTypeClick(typeId: PokemonTypeId) {
        selectedTypeId.value = typeId
    }

    override fun onPokemonClick(pokemonId: PokemonId) {
        val pokemon = pokemonsState.value.data?.find { it.id == pokemonId } ?: return
        onOutput(PokemonListComponent.Output.PokemonDetailsRequested(pokemon))
    }

    override fun onRetryClick() {
        pokemonsByTypeReplica.refresh(selectedTypeId.value)
    }

    override fun onRefresh() {
        pokemonsByTypeReplica.refresh(selectedTypeId.value)
    }

    @Serializable
    private data class PersistentState(
        val selectedTypeId: PokemonTypeId
    )
}