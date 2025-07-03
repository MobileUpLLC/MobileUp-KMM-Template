package ru.mobileup.kmm_template.features.flow2.presentation.screen2B

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeScreen2BComponent : Screen2BComponent {

    override val text = MutableStateFlow(StringDesc.Raw("Screen 2B") as StringDesc)

    override fun onNextClick() = Unit
}