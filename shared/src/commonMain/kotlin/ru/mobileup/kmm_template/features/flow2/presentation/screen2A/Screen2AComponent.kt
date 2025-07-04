package ru.mobileup.kmm_template.features.flow2.presentation.screen2A

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow

interface Screen2AComponent {

    val text: StateFlow<StringDesc>

    fun onNextClick()

    sealed interface Output {
        object Next : Output
    }
}