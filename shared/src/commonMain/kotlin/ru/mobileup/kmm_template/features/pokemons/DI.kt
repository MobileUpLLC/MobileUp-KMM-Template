package ru.mobileup.kmm_template.features.pokemons

import com.arkivanov.decompose.ComponentContext
import me.aartikov.replica.algebra.normal.withKey
import org.koin.core.component.get
import org.koin.dsl.module
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.network.NetworkApiFactory
import ru.mobileup.kmm_template.features.pokemons.data.PokemonApi
import ru.mobileup.kmm_template.features.pokemons.data.PokemonRepository
import ru.mobileup.kmm_template.features.pokemons.data.PokemonRepositoryImpl
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorage
import ru.mobileup.kmm_template.features.pokemons.data.PokemonVotesStorageImpl
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.vote.GetAllVotesForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.domain.vote.GetVoteForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.domain.vote.SetVoteForPokemonInteractor
import ru.mobileup.kmm_template.features.pokemons.ui.PokemonsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.RealPokemonsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.RealPokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.RealPokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteDialogData
import ru.mobileup.kmm_template.features.pokemons.ui.list.PokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.ui.list.RealPokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.PokemonVotesComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.RealPokemonVotesComponent

val pokemonsModule = module {
    single { get<NetworkApiFactory>().unauthorizedKtorfit.create<PokemonApi>() }
    single<PokemonRepository> { PokemonRepositoryImpl(get(), get()) }
    single<PokemonVotesStorage> { PokemonVotesStorageImpl() }
    factory { GetVoteForPokemonInteractor(get()) }
    factory { SetVoteForPokemonInteractor(get()) }
    factory { GetAllVotesForPokemonInteractor(get()) }
}

fun ComponentFactory.createPokemonsComponent(
    componentContext: ComponentContext
): PokemonsComponent {
    return RealPokemonsComponent(componentContext, get())
}

fun ComponentFactory.createPokemonListComponent(
    componentContext: ComponentContext,
    onOutput: (PokemonListComponent.Output) -> Unit
): PokemonListComponent {
    val pokemonsByTypeReplica = get<PokemonRepository>().pokemonsByTypeReplica
    return RealPokemonListComponent(componentContext, onOutput, pokemonsByTypeReplica, get())
}

fun ComponentFactory.createPokemonDetailsComponent(
    componentContext: ComponentContext,
    pokemonId: PokemonId,
    pokemonName: String
): PokemonDetailsComponent {
    val pokemonReplica = get<PokemonRepository>().pokemonByIdReplica.withKey(pokemonId)
    return RealPokemonDetailsComponent(
        componentContext,
        pokemonName,
        pokemonReplica,
        get(),
        get(),
        get(),
        get()
    )
}

fun ComponentFactory.createPokemonVoteDialogComponent(
    componentContext: ComponentContext,
    pokemonVoteDialogData: PokemonVoteDialogData,
    dialogControl: DialogControl<PokemonVoteDialogComponent.Config, PokemonVoteDialogComponent>,
    onOutput: (PokemonVoteDialogComponent.Output) -> Unit
): PokemonVoteDialogComponent {
    return RealPokemonVoteDialogComponent(
        componentContext,
        pokemonVoteDialogData,
        dialogControl,
        onOutput
    )
}

fun ComponentFactory.createPokemonVotesComponent(
    componentContext: ComponentContext,
): PokemonVotesComponent {
    return RealPokemonVotesComponent(
        componentContext,
        get()
    )
}