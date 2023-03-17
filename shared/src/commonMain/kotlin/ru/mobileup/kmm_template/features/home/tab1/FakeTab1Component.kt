package ru.mobileup.kmm_template.features.home.tab1

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeTab1Component : Tab1Component {

    override val text = CMutableStateFlow(StringDesc.Raw("Tab 1") as StringDesc)

    override fun onExitClick() = Unit
}