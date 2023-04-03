package ru.mobileup.kmm_template.features.pokemons.ui.details

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.dialog.FakeDialogControl
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.LoadableState
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.FakePokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteState

class FakePokemonDetailsComponent : PokemonDetailsComponent {
    override val pokemonVoteState: CStateFlow<PokemonVoteState> = CMutableStateFlow(PokemonVoteState.NONE)

    override val title: StringDesc = StringDesc.Raw("Bulbasaur")

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

    override val dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent> =
        FakeDialogControl(FakePokemonVoteDialogComponent())

    override fun onVoteClick() = Unit

    override fun onRetryClick() = Unit

    override fun onRefresh() = Unit
}