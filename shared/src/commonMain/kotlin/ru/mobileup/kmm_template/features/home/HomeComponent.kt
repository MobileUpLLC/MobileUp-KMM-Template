package ru.mobileup.kmm_template.features.home

import co.touchlab.skie.configuration.annotations.FlowInterop
import co.touchlab.skie.configuration.annotations.SealedInterop
import com.arkivanov.decompose.router.stack.ChildStack
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.features.home.tab1.Tab1Component
import ru.mobileup.kmm_template.features.home.tab2.Tab2Component
import ru.mobileup.kmm_template.features.pokemons.ui.PokemonsComponent

interface HomeComponent {

    @FlowInterop.Enabled
    val childStack: StateFlow<ChildStack<*, Child>>

    fun onTabSelected(tab: HomeTab)

    @SealedInterop.Enabled
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