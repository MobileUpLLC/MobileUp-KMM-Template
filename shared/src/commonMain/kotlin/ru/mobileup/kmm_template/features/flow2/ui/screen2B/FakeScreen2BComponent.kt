package ru.mobileup.kmm_template.features.flow2.ui.screen2B

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen2BComponent : Screen2BComponent {

    override val text = CMutableStateFlow(StringDesc.Raw("Screen 2B") as StringDesc)

    override fun onNextClick() = Unit
}