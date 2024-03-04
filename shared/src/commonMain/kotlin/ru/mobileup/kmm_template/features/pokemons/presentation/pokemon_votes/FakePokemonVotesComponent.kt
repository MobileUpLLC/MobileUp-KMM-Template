package ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes

import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

class FakePokemonVotesComponent : PokemonVotesComponent {
    override val pokemonVotes: CStateFlow<PokemonVotes> = CMutableStateFlow(PokemonVotes(emptyList()))
}