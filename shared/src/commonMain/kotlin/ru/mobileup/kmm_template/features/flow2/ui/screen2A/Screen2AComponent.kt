package ru.mobileup.kmm_template.features.flow2.ui.screen2A

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen2AComponent {

    val text: CStateFlow<StringDesc>

    fun onNextClick()

    sealed interface Output {
        object Next : Output
    }
}