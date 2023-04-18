package ru.mobileup.kmm_template.features.root.ui

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.childContext
import com.arkivanov.decompose.router.stack.*
import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.parcelable.Parcelize
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.message.createMessageComponent
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import ru.mobileup.kmm_template.features.flow1.createFlow1Component
import ru.mobileup.kmm_template.features.flow1.ui.Flow1Component
import ru.mobileup.kmm_template.features.flow2.createFlow2Component
import ru.mobileup.kmm_template.features.flow2.ui.Flow2Component
import ru.mobileup.kmm_template.features.home.HomeComponent
import ru.mobileup.kmm_template.features.home.createHomeComponent

class RealRootComponent(
    componentContext: ComponentContext,
    private val componentFactory: ComponentFactory
) : ComponentContext by componentContext, RootComponent {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: CStateFlow<ChildStack<*, RootComponent.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Flow1,
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
        is ChildConfig.Flow1 -> {
            RootComponent.Child.Flow1(
                componentFactory.createFlow1Component(componentContext, ::onFlow1Output)
            )
        }

        is ChildConfig.Home -> {
            RootComponent.Child.Home(
                componentFactory.createHomeComponent(componentContext, ::onHomeOutput)
            )
        }

        is ChildConfig.Flow2 -> {
            RootComponent.Child.Flow2(
                componentFactory.createFlow2Component(componentContext, ::onFlow2Output)
            )
        }
    }

    private fun onFlow1Output(output: Flow1Component.Output) {
        when (output) {
            is Flow1Component.Output.Finished -> {
                navigation.replaceAll(ChildConfig.Home)
            }
        }
    }

    private fun onHomeOutput(output: HomeComponent.Output) {
        when (output) {
            HomeComponent.Output.ExitRequested -> {
                navigation.replaceAll(ChildConfig.Flow1)
            }

            HomeComponent.Output.Flow2Requested -> {
                navigation.push(ChildConfig.Flow2)
            }
        }
    }

    private fun onFlow2Output(output: Flow2Component.Output) {
        when (output) {
            is Flow2Component.Output.Finished -> {
                navigation.pop()
            }
        }
    }

    private sealed interface ChildConfig : Parcelable {

        @Parcelize
        object Flow1 : ChildConfig

        @Parcelize
        object Home : ChildConfig

        @Parcelize
        object Flow2 : ChildConfig
    }
}