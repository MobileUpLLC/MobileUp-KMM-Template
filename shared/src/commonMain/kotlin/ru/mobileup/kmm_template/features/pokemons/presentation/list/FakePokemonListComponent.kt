package ru.mobileup.kmm_template.features.pokemons.presentation.list

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId

class FakePokemonListComponent : PokemonListComponent {

    override val types = CMutableStateFlow(
        listOf(
            PokemonType.Fire,
            PokemonType.Water,
            PokemonType.Electric,
            PokemonType.Grass,
            PokemonType.Poison
        )
    )

    override val selectedTypeId = CMutableStateFlow(types.value[0].id)

    override val pokemonsState = CMutableStateFlow(
        LoadableState(
            loading = false,
            data = listOf(
                Pokemon(
                    id = PokemonId("1"),
                    name = "Bulbasaur"
                ),
                Pokemon(
                    id = PokemonId("5"),
                    name = "Charmeleon"
                ),
                Pokemon(
                    id = PokemonId("7"),
                    name = "Squirtle"
                )
            )
        )
    )

    override fun onTypeClick(typeId: PokemonTypeId) = Unit

    override fun onPokemonClick(pokemonId: PokemonId) = Unit

    override fun onRetryClick() = Unit

    override fun onRefresh() = Unit
}