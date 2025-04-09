package ru.mobileup.kmm_template.features.flow2.presentation.screen2C

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Screen2CComponent {

    val text: StateFlow<StringDesc>

    fun onFinishClick()

    sealed interface Output {
        object Finish : Output
    }
}