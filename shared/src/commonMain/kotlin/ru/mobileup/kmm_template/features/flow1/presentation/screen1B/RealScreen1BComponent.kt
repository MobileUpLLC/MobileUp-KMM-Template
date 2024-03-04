package ru.mobileup.kmm_template.features.flow1.presentation.screen1B

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class RealScreen1BComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen1BComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen1BComponent {

    override val title = CMutableStateFlow(StringDesc.Raw("Screen 1B") as StringDesc)

    override fun onNextClick() {
        onOutput(Screen1BComponent.Output.Next)
    }
}