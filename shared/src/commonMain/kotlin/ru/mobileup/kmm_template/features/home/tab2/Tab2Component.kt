package ru.mobileup.kmm_template.features.home.tab2

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Tab2Component {

    val text: CStateFlow<StringDesc>

    fun onStartFlow2Click()

    sealed interface Output {
        object Flow2Requested : Output
    }
}