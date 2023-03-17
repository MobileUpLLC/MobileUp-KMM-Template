package ru.mobileup.kmm_template.features.flow2.ui.screen2A

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen2AComponent : Screen2AComponent {

    override val text = CMutableStateFlow(StringDesc.Raw("Screen 2A") as StringDesc)

    override fun onNextClick() = Unit
}