package ru.mobileup.kmm_template.features.home.tab2

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class RealTab2Component(
    componentContext: ComponentContext,
    private val onOutput: (Tab2Component.Output) -> Unit
) : ComponentContext by componentContext, Tab2Component {

    override val text = CMutableStateFlow(StringDesc.Raw("Tab 2") as StringDesc)

    override fun onStartFlow2Click() {
        onOutput(Tab2Component.Output.Flow2Requested)
    }
}