package ru.mobileup.kmm_template.features.flow1.presentation.screen1C

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen1CComponent : Screen1CComponent {

    override val title = CMutableStateFlow(StringDesc.Raw("Screen1C") as StringDesc)

    override fun onFinishClick() = Unit
}