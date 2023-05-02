package ru.mobileup.kmm_template.features.pokemons.ui

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.decompose.router.stack.push
import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.bottom_sheet.BottomSheetControl
import ru.mobileup.kmm_template.core.bottom_sheet.bottomSheetControl
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.pokemons.createPokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.createPokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.createPokemonVotesComponent
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.ui.list.PokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.ui.pokemon_votes.PokemonVotesComponent

class RealPokemonsComponent(
    componentContext: ComponentContext,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, PokemonsComponent {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, PokemonsComponent.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.List,
        handleBackButton = true,
        childFactory = ::createChild
    ).toCStateFlow(lifecycle)

    /**
     * Создание ботомшита без ключа, т.к. он уникален для данного компонента.
     * В параметре 'config' можно указать payload данные
     */
    override val bottomSheetControl: BottomSheetControl<PokemonVotesComponent.Config, PokemonVotesComponent> =
        bottomSheetControl(
            bottomSheetComponentFactory = { config, context, _ ->
                componentFactory.createPokemonVotesComponent(context)
            },
            halfExpandingSupported = true,
            hidingSupported = true,
            handleBackButton = true
        )

    /**
     * Для показа ботомшита есть метод 'show', а для закрытия 'dismiss'
     */
    override fun onPokemonVotesButtonClick() {
        bottomSheetControl.show(PokemonVotesComponent.Config)
    }

    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): PokemonsComponent.Child = when (config) {
        is ChildConfig.List -> {
            PokemonsComponent.Child.List(
                componentFactory.createPokemonListComponent(
                    componentContext,
                    ::onPokemonListOutput
                )
            )
        }

        is ChildConfig.Details -> {
            PokemonsComponent.Child.Details(
                componentFactory.createPokemonDetailsComponent(
                    componentContext,
                    config.pokemonId,
                    config.pokemonName
                )
            )
        }
    }

    private fun onPokemonListOutput(output: PokemonListComponent.Output) {
        when (output) {
            is PokemonListComponent.Output.PokemonDetailsRequested -> {
                navigation.push(ChildConfig.Details(output.pokemon.id, output.pokemon.name))
            }
        }
    }

    private sealed interface ChildConfig : Parcelable {

        @Parcelize
        object List : ChildConfig

        @Parcelize
        data class Details(val pokemonId: PokemonId, val pokemonName: String) : ChildConfig
    }
}