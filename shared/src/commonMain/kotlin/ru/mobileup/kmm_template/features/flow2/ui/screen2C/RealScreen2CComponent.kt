package ru.mobileup.kmm_template.features.flow2.ui.screen2C

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class RealScreen2CComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen2CComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen2CComponent {

    override val text = CMutableStateFlow(StringDesc.Raw("Screen 2C") as StringDesc)

    override fun onFinishClick() {
        onOutput(Screen2CComponent.Output.Finish)
    }
}