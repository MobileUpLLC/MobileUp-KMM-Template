package ru.mobileup.kmm_template.features.flow1.presentation.screen1A

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow

interface Screen1AComponent {

    val title: StateFlow<StringDesc>

    fun onNextClick()

    sealed interface Output {
        object Next : Output
    }
}