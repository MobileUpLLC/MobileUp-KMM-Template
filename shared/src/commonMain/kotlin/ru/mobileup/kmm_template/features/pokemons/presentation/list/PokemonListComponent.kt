package ru.mobileup.kmm_template.features.pokemons.presentation.list

import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId

interface PokemonListComponent {

    val types: StateFlow<List<PokemonType>>

    val selectedTypeId: StateFlow<PokemonTypeId>

    val pokemonsState: StateFlow<LoadableState<List<Pokemon>>>

    fun onTypeClick(typeId: PokemonTypeId)

    fun onPokemonClick(pokemonId: PokemonId)

    fun onRetryClick()

    fun onRefresh()

    sealed interface Output {
        data class PokemonDetailsRequested(val pokemon: Pokemon) : Output
    }
}