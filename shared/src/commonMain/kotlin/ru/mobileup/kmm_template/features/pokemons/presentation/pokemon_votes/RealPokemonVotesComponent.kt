package ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes

import com.arkivanov.decompose.ComponentContext
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.GetAllVotesForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVotes

class RealPokemonVotesComponent(
    componentContext: ComponentContext,
    getAllVotesForPokemonInteractor: GetAllVotesForPokemonInteractor
) : PokemonVotesComponent, ComponentContext by componentContext {
    override val pokemonVotes: StateFlow<PokemonVotes> =
        getAllVotesForPokemonInteractor.execute()
}