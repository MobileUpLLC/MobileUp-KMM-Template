package ru.mobileup.kmm_template.features.flow2.ui.screen2C

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen2CComponent {

    val text: CStateFlow<StringDesc>

    fun onFinishClick()

    sealed interface Output {
        object Finish : Output
    }
}