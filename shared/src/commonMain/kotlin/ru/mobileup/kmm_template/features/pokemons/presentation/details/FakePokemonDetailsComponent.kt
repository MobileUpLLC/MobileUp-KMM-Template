package ru.mobileup.kmm_template.features.pokemons.presentation.details

import dev.icerock.moko.graphics.Color
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.dialog.fakeDialogControl
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.FakePokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteDialogData
import ru.mobileup.kmm_template.features.pokemons.presentation.details.vote.model.PokemonVoteState

class FakePokemonDetailsComponent : PokemonDetailsComponent {
    override val pokemonVoteState: StateFlow<PokemonVoteState> = MutableStateFlow(PokemonVoteState.NONE)

    override val title: StringDesc = StringDesc.Raw("Bulbasaur")

    override val pokemonState = MutableStateFlow(
        LoadableState(
            loading = false,
            data = DetailedPokemon(
                id = PokemonId("12"),
                name = "Bulbasaur",
                imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                height = 0.7f,
                weight = 6.9f,
                types = listOf(PokemonType.Grass, PokemonType.Poison)
            )
        )
    )

    override val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent> =
        fakeDialogControl(
            config = PokemonVoteDialogComponent.Config(
                PokemonVoteDialogData(
                    pokemonName = "pokemon",
                    pokemonTypes = listOf(PokemonType.Grass.name)
                )
            ),
            component = FakePokemonVoteDialogComponent()
        )

    override fun onVoteClick() = Unit

    override fun onRetryClick() = Unit

    override fun onRefresh() = Unit

    override fun getPokemonColor(type: PokemonType): Color { return Color(0xFF6C6CFF) }
}