package ru.mobileup.kmm_template.features.home

import com.arkivanov.decompose.router.stack.ChildStack
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.home.tab1.Tab1Component
import ru.mobileup.kmm_template.features.home.tab2.Tab2Component
import ru.mobileup.kmm_template.features.pokemons.presentation.PokemonsComponent

interface HomeComponent {

    val childStack: StateFlow<ChildStack<*, Child>>

    fun onTabSelected(tab: HomeTab)

    sealed class Child {
        class Tab1(val component: Tab1Component) : Child()
        class Tab2(val component: Tab2Component) : Child()
        class Tab3(val component: PokemonsComponent) : Child()
    }

    sealed interface Output {
        object ExitRequested : Output
        object Flow2Requested : Output
    }
}