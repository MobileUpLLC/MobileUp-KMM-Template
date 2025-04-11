package ru.mobileup.kmm_template.features.flow2.presentation.screen2C

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeScreen2CComponent : Screen2CComponent {

    override val text = MutableStateFlow(StringDesc.Raw("Screen 2C") as StringDesc)

    override fun onFinishClick() = Unit
}