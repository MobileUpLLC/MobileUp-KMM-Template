package ru.mobileup.kmm_template.features.flow1.presentation.screen1A

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealScreen1AComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen1AComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen1AComponent {

    override val title = MutableStateFlow(StringDesc.Raw("Screen 1A") as StringDesc)

    override fun onNextClick() {
        onOutput(Screen1AComponent.Output.Next)
    }
}