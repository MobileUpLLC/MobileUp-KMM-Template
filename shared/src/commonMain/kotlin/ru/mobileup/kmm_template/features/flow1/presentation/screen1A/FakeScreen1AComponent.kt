package ru.mobileup.kmm_template.features.flow1.presentation.screen1A

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow

class FakeScreen1AComponent : Screen1AComponent {

    override val title = MutableStateFlow(StringDesc.Raw("Screen1A") as StringDesc)

    override fun onNextClick() = Unit
}