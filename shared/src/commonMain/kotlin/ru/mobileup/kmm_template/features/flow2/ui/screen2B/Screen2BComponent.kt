package ru.mobileup.kmm_template.features.flow2.ui.screen2B

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen2BComponent {

    val text: CStateFlow<StringDesc>

    fun onNextClick()

    sealed interface Output {
        object Next : Output
    }
}