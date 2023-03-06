package ru.mobileup.kmm_template.features.pokemons.ui.details

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType

class FakePokemonDetailsComponent : PokemonDetailsComponent {

    override val pokemonState = CMutableStateFlow(
        LoadableState(
            loading = true,
            data = DetailedPokemon(
                id = PokemonId("1"),
                name = "Bulbasaur",
                imageUrl = "",
                height = 0.7f,
                weight = 6.9f,
                types = listOf(PokemonType.Grass, PokemonType.Poison)
            )
        )
    )

    override fun onRetryClick() = Unit

    override fun onRefresh() = Unit
}