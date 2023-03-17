package ru.mobileup.kmm_template.features.flow1.ui.screen1C

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class RealScreen1CComponent(
    componentContext: ComponentContext,
    private val onOutput: (Screen1CComponent.Output) -> Unit
) : ComponentContext by componentContext, Screen1CComponent {

    override val title = CMutableStateFlow(StringDesc.Raw("Screen 1C") as StringDesc)

    override fun onFinishClick() {
        onOutput(Screen1CComponent.Output.Finish)
    }
}