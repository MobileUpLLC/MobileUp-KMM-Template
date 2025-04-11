package ru.mobileup.kmm_template.features.flow2.presentation.screen2A

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealScreen2AComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen2AComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen2AComponent {

    override val text = MutableStateFlow(StringDesc.Raw("Screen 2A") as StringDesc)

    override fun onNextClick() {
        onOutput(Screen2AComponent.Output.Next)
    }
}