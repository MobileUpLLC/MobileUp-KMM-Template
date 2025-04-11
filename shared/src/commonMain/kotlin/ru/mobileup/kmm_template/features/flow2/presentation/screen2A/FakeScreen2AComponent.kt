package ru.mobileup.kmm_template.features.flow2.presentation.screen2A

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeScreen2AComponent : Screen2AComponent {

    override val text = MutableStateFlow(StringDesc.Raw("Screen 2A") as StringDesc)

    override fun onNextClick() = Unit
}