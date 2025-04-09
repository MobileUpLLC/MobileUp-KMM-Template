package ru.mobileup.kmm_template.features.home.tab2

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Tab2Component {

    val text: StateFlow<StringDesc>

    fun onStartFlow2Click()

    sealed interface Output {
        object Flow2Requested : Output
    }
}