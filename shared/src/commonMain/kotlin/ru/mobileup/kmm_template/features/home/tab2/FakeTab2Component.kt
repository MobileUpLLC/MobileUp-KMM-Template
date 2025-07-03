package ru.mobileup.kmm_template.features.home.tab2

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeTab2Component : Tab2Component {

    override val text = MutableStateFlow(StringDesc.Raw("Tab 2") as StringDesc)

    override fun onStartFlow2Click() = Unit
}