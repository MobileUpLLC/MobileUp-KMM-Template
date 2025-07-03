package ru.mobileup.kmm_template.features.home.tab1

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class RealTab1Component(
    componentContext: ComponentContext,
    private val onOutput: (Tab1Component.Output) -> Unit
) : ComponentContext by componentContext, Tab1Component {

    override val text = MutableStateFlow(StringDesc.Raw("Tab 1") as StringDesc)

    override fun onExitClick() {
        onOutput(Tab1Component.Output.ExitRequested)
    }
}