package ru.mobileup.kmm_template.features.flow1.presentation.screen1B

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealScreen1BComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen1BComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen1BComponent {

    override val title = MutableStateFlow(StringDesc.Raw("Screen 1B") as StringDesc)

    override fun onNextClick() {
        onOutput(Screen1BComponent.Output.Next)
    }
}