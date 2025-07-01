package ru.mobileup.kmm_template.features.home

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.bringToFront
import com.arkivanov.decompose.router.stack.childStack
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.utils.toStateFlow
import ru.mobileup.kmm_template.features.home.tab1.Tab1Component
import ru.mobileup.kmm_template.features.home.tab2.Tab2Component
import ru.mobileup.kmm_template.features.pokemons.createPokemonsComponent

class RealHomeComponent(
    componentContext: ComponentContext,
    private val onOutput: (HomeComponent.Output) -> Unit,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, HomeComponent {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: StateFlow<ChildStack<*, HomeComponent.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Tab1,
        serializer = ChildConfig.serializer(),
        childFactory = ::createChild
    ).toStateFlow(lifecycle)

    override val selectedTab: MutableStateFlow<HomeTab> = MutableStateFlow(HomeTab.Tab1)

    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): HomeComponent.Child = when (config) {
        ChildConfig.Tab1 -> HomeComponent.Child.Tab1(
            componentFactory.createTab1Component(componentContext, ::onTab1Output)
        )

        ChildConfig.Tab2 -> HomeComponent.Child.Tab2(
            componentFactory.createTab2Component(componentContext, ::onTab2Output)
        )

        ChildConfig.Tab3 -> HomeComponent.Child.Tab3(
            componentFactory.createPokemonsComponent(componentContext)
        )
    }

    override fun onTabSelected(tab: HomeTab) {
        navigation.bringToFront(tab.toChildConfig())
        selectedTab.value = tab
    }

    private fun onTab1Output(output: Tab1Component.Output) {
        when (output) {
            is Tab1Component.Output.ExitRequested -> {
                onOutput(HomeComponent.Output.ExitRequested)
            }
        }
    }

    private fun onTab2Output(output: Tab2Component.Output) {
        when (output) {
            is Tab2Component.Output.Flow2Requested -> {
                onOutput(HomeComponent.Output.Flow2Requested)
            }
        }
    }

    private fun HomeTab.toChildConfig(): ChildConfig = when (this) {
        HomeTab.Tab1 -> ChildConfig.Tab1
        HomeTab.Tab2 -> ChildConfig.Tab2
        HomeTab.Tab3 -> ChildConfig.Tab3
    }

    @Serializable
    private sealed interface ChildConfig {

        @Serializable
        object Tab1 : ChildConfig

        @Serializable
        object Tab2 : ChildConfig

        @Serializable
        object Tab3 : ChildConfig
    }
}