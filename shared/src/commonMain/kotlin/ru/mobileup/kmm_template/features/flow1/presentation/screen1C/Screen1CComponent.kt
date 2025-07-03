package ru.mobileup.kmm_template.features.flow1.presentation.screen1C

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow

interface Screen1CComponent {

    val title: StateFlow<StringDesc>

    fun onFinishClick()

    sealed interface Output {
        object Finish : Output
    }
}