package ru.mobileup.kmm_template.features.pokemons.data

import me.aartikov.replica.keyed.KeyedReplica
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId

interface PokemonRepository {

    val pokemonsByTypeReplica: KeyedReplica<PokemonTypeId, List<Pokemon>>

    val pokemonByIdReplica: KeyedReplica<PokemonId, DetailedPokemon>
}