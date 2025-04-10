package ru.mobileup.kmm_template.features.flow2.presentation.screen2B

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealScreen2BComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen2BComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen2BComponent {

    override val text = MutableStateFlow(StringDesc.Raw("Screen 2B") as StringDesc)

    override fun onNextClick() {
        onOutput(Screen2BComponent.Output.Next)
    }
}