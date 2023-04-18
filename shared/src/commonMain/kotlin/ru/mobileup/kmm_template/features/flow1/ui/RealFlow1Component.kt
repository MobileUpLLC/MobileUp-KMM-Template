package ru.mobileup.kmm_template.features.flow1.ui

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.router.stack.StackNavigation
import com.arkivanov.decompose.router.stack.childStack
import com.arkivanov.decompose.router.stack.push
import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.flow1.createScreen1AComponent
import ru.mobileup.kmm_template.features.flow1.createScreen1BComponent
import ru.mobileup.kmm_template.features.flow1.createScreen1CComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.Screen1AComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1B.Screen1BComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1C.Screen1CComponent

class RealFlow1Component(
    componentContext: ComponentContext,
    private val onOutput: (Flow1Component.Output) -> Unit,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, Flow1Component {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, Flow1Component.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Screen1A,
        handleBackButton = true,
        childFactory = ::createChild
    ).toCStateFlow(lifecycle)

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
                navigation.push(ChildConfig.Screen1B)
            }
        }
    }

    private fun onScreen1BOutput(output: Screen1BComponent.Output) {
        when (output) {
            is Screen1BComponent.Output.Next -> {
                navigation.push(ChildConfig.Screen1C)
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

    private sealed interface ChildConfig : Parcelable {

        @Parcelize
        object Screen1A : ChildConfig

        @Parcelize
        object Screen1B : ChildConfig

        @Parcelize
        object Screen1C : ChildConfig
    }
}