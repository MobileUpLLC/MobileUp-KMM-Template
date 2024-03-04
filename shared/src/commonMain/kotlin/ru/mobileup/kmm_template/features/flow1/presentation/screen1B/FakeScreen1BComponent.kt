package ru.mobileup.kmm_template.features.flow1.presentation.screen1B

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CMutableStateFlow

class FakeScreen1BComponent : Screen1BComponent {

    override val title = CMutableStateFlow(StringDesc.Raw("Screen1B") as StringDesc)

    override fun onNextClick() = Unit
}