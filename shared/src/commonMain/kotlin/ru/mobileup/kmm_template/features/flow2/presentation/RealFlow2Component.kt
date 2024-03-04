package ru.mobileup.kmm_template.features.flow2.presentation

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.decompose.router.stack.push
import kotlinx.serialization.Serializable
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.flow2.createScreen2AComponent
import ru.mobileup.kmm_template.features.flow2.createScreen2BComponent
import ru.mobileup.kmm_template.features.flow2.createScreen2CComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2A.Screen2AComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2B.Screen2BComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2C.Screen2CComponent

class RealFlow2Component(
    componentContext: ComponentContext,
    private val onOutput: (Flow2Component.Output) -> Unit,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, Flow2Component {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, Flow2Component.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Screen2A,
        serializer = ChildConfig.serializer(),
        handleBackButton = true,
        childFactory = ::createChild
    ).toCStateFlow(lifecycle)

    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): Flow2Component.Child = when (config) {
        ChildConfig.Screen2A -> Flow2Component.Child.Screen2A(
            componentFactory.createScreen2AComponent(componentContext, ::onScreen2AOutput)
        )

        ChildConfig.Screen2B -> Flow2Component.Child.Screen2B(
            componentFactory.createScreen2BComponent(componentContext, ::onScreen2BOutput)
        )

        ChildConfig.Screen2C -> Flow2Component.Child.Screen2C(
            componentFactory.createScreen2CComponent(componentContext, ::onScreen2COutput)
        )
    }

    private fun onScreen2AOutput(output: Screen2AComponent.Output) {
        when (output) {
            is Screen2AComponent.Output.Next -> {
                navigation.push(ChildConfig.Screen2B)
            }
        }
    }

    private fun onScreen2BOutput(output: Screen2BComponent.Output) {
        when (output) {
            is Screen2BComponent.Output.Next -> {
                navigation.push(ChildConfig.Screen2C)
            }
        }
    }

    private fun onScreen2COutput(output: Screen2CComponent.Output) {
        when (output) {
            is Screen2CComponent.Output.Finish -> {
                onOutput(Flow2Component.Output.Finished)
            }
        }
    }

    @Serializable
    private sealed interface ChildConfig {

        @Serializable
        object Screen2A : ChildConfig

        @Serializable
        object Screen2B : ChildConfig

        @Serializable
        object Screen2C : ChildConfig
    }
}