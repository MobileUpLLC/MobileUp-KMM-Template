package ru.mobileup.kmm_template.features.root.ui

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.childContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.message.createMessageComponent
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.pokemons.createPokemonsComponent

class RealRootComponent(
    componentContext: ComponentContext,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, RootComponent {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, RootComponent.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Pokemons,
        handleBackButton = true,
        childFactory = ::createChild
    ).toCStateFlow(lifecycle)

    override val messageComponent = componentFactory.createMessageComponent(
        childContext(key = "message")
    )

    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): RootComponent.Child = when (config) {
        is ChildConfig.Pokemons -> {
            RootComponent.Child.Pokemons(
                componentFactory.createPokemonsComponent(componentContext)
            )
        }
    }

    private sealed interface ChildConfig : Parcelable {

        @Parcelize
        object Pokemons : ChildConfig
    }
}