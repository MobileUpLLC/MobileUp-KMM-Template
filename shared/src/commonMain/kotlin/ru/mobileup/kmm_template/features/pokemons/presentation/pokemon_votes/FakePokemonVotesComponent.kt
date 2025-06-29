package ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

class FakePokemonVotesComponent : PokemonVotesComponent {
    override val pokemonVotes: StateFlow<PokemonVotes> = MutableStateFlow(PokemonVotes(emptyList()))
}