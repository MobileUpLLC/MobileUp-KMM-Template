package ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes

import com.arkivanov.decompose.ComponentContext
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.domain.vote.GetAllVotesForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.domain.vote.PokemonVote

class RealPokemonVotesComponent(
    componentContext: ComponentContext,
    getAllVotesForPokemonInteractor: GetAllVotesForPokemonInteractor
) : PokemonVotesComponent, ComponentContext by componentContext {
    override val pokemonVotes: CStateFlow<List<PokemonVote>> =
        getAllVotesForPokemonInteractor.execute()
}