package ru.mobileup.kmm_template.features.home.tab1

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeTab1Component : Tab1Component {

    override val text = MutableStateFlow(StringDesc.Raw("Tab 1") as StringDesc)

    override fun onExitClick() = Unit
}