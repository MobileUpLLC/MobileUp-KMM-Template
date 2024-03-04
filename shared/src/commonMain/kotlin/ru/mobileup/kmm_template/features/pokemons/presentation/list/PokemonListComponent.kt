package ru.mobileup.kmm_template.features.pokemons.presentation.list

import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId

interface PokemonListComponent {

    val types: CStateFlow<List<PokemonType>>

    val selectedTypeId: CStateFlow<PokemonTypeId>

    val pokemonsState: CStateFlow<LoadableState<List<Pokemon>>>

    fun onTypeClick(typeId: PokemonTypeId)

    fun onPokemonClick(pokemonId: PokemonId)

    fun onRetryClick()

    fun onRefresh()

    sealed interface Output {
        data class PokemonDetailsRequested(val pokemon: Pokemon) : Output
    }
}