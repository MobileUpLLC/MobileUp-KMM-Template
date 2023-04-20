package ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.ListWrapper
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote

class FakePokemonVotesComponent : PokemonVotesComponent {
    override val pokemonVotes: CStateFlow<ListWrapper<PokemonVote>> = CMutableStateFlow(ListWrapper(emptyList()))
}