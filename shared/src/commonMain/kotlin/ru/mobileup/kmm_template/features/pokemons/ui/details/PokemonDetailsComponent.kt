package ru.mobileup.kmm_template.features.pokemons.ui.details

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon

interface PokemonDetailsComponent {

    val title: StringDesc

    val pokemonState: CStateFlow<LoadableState<DetailedPokemon>>

    fun onRetryClick()

    fun onRefresh()
}