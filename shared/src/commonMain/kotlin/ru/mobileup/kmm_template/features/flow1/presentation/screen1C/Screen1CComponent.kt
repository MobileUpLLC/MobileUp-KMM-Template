package ru.mobileup.kmm_template.features.flow1.presentation.screen1C

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen1CComponent {

    val title: CStateFlow<StringDesc>

    fun onFinishClick()

    sealed interface Output {
        object Finish : Output
    }
}