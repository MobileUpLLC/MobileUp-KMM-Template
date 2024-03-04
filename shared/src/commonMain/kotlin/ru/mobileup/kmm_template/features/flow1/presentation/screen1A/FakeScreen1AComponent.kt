package ru.mobileup.kmm_template.features.flow1.presentation.screen1A

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen1AComponent : Screen1AComponent {

    override val title = CMutableStateFlow(StringDesc.Raw("Screen1A") as StringDesc)

    override fun onNextClick() = Unit
}