package ru.mobileup.kmm_template.features.flow1.presentation.screen1C

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealScreen1CComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen1CComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen1CComponent {

    override val title = MutableStateFlow(StringDesc.Raw("Screen 1C") as StringDesc)

    override fun onFinishClick() {
        onOutput(Screen1CComponent.Output.Finish)
    }
}