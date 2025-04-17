package ru.mobileup.kmm_template.features.pokemons.presentation

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.decompose.router.stack.pushNew
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.dialog.DialogControl
import ru.mobileup.kmm_template.core.dialog.dialogControl
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.pokemons.createPokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.createPokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.createPokemonVotesComponent
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.presentation.list.PokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes.PokemonVotesComponent

class RealPokemonsComponent(
    componentContext: ComponentContext,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, PokemonsComponent {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, PokemonsComponent.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.List,
        serializer = ChildConfig.serializer(),
        handleBackButton = true,
        childFactory = ::createChild
    ).toCStateFlow(lifecycle)

    /**
     * Создание ботомшита без ключа, т.к. он уникален для данного компонента.
     * В параметре 'config' можно указать payload данные
     */
    override val bottomSheetControl: DialogControl<PokemonVotesComponent.Config, PokemonVotesComponent> =
        dialogControl(
            key = "bottomSheetControl",
            dialogComponentFactory = { config, context, _ ->
                componentFactory.createPokemonVotesComponent(context)
            },
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
                navigation.pushNew(ChildConfig.Details(output.pokemon.id, output.pokemon.name))
            }
        }
    }

    @Serializable
    private sealed interface ChildConfig {

        @Serializable
        object List : ChildConfig

        @Serializable
        data class Details(val pokemonId: PokemonId, val pokemonName: String) : ChildConfig
    }
}