package ru.mobileup.kmm_template.features.flow1.presentation

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.decompose.router.stack.pushNew
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.utils.componentScope
import ru.mobileup.kmm_template.core.utils.toStateFlow
import ru.mobileup.kmm_template.features.flow1.createScreen1AComponent
import ru.mobileup.kmm_template.features.flow1.createScreen1BComponent
import ru.mobileup.kmm_template.features.flow1.createScreen1CComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1A.Screen1AComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.Screen1BComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1C.Screen1CComponent

class RealFlow1Component(
    componentContext: ComponentContext,
    private val onOutput: (Flow1Component.Output) -> Unit,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, Flow1Component {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: StateFlow<ChildStack<*, Flow1Component.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Screen1A,
        serializer = ChildConfig.serializer(),
        handleBackButton = true,
        childFactory = ::createChild
    ).toStateFlow(lifecycle)

    init {
        childStack
            .onEach {
                println("Flow1Component: ${it.items.map { it.instance }}")
            }
            .launchIn(componentScope)
    }

    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): Flow1Component.Child = when (config) {
        ChildConfig.Screen1A -> Flow1Component.Child.Screen1A(
            componentFactory.createScreen1AComponent(componentContext, ::onScreen1AOutput)
        )

        ChildConfig.Screen1B -> Flow1Component.Child.Screen1B(
            componentFactory.createScreen1BComponent(componentContext, ::onScreen1BOutput)
        )

        ChildConfig.Screen1C -> Flow1Component.Child.Screen1C(
            componentFactory.createScreen1CComponent(componentContext, ::onScreen1COutput)
        )
    }

    private fun onScreen1AOutput(output: Screen1AComponent.Output) {
        when (output) {
            is Screen1AComponent.Output.Next -> {
                navigation.pushNew(ChildConfig.Screen1B)
            }
        }
    }

    private fun onScreen1BOutput(output: Screen1BComponent.Output) {
        when (output) {
            is Screen1BComponent.Output.Next -> {
                navigation.pushNew(ChildConfig.Screen1C)
            }
        }
    }

    private fun onScreen1COutput(output: Screen1CComponent.Output) {
        when (output) {
            is Screen1CComponent.Output.Finish -> {
                onOutput(Flow1Component.Output.Finished)
            }
        }
    }

    @Serializable
    private sealed interface ChildConfig {

        @Serializable
        object Screen1A : ChildConfig

        @Serializable
        object Screen1B : ChildConfig

        @Serializable
        object Screen1C : ChildConfig
    }
}