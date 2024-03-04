package ru.mobileup.kmm_template.features.flow2.presentation.screen2C

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen2CComponent : Screen2CComponent {

    override val text = CMutableStateFlow(StringDesc.Raw("Screen 2C") as StringDesc)

    override fun onFinishClick() = Unit
}