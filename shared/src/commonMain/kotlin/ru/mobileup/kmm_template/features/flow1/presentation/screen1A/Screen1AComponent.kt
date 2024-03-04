package ru.mobileup.kmm_template.features.flow1.presentation.screen1A

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen1AComponent {

    val title: CStateFlow<StringDesc>

    fun onNextClick()

    sealed interface Output {
        object Next : Output
    }
}