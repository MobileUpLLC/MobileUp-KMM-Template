package ru.mobileup.kmm_template.features.pokemons.ui

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.pokemons.ui.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.list.PokemonListComponent

interface PokemonsComponent {

    val childStack: CStateFlow<ChildStack<*, Child>>

    sealed class Child {
        class List(val component: PokemonListComponent) : Child()
        class Details(val component: PokemonDetailsComponent) : Child()
    }
}