package ru.mobileup.kmm_template.features.home.tab1

import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.state.CStateFlow

interface Tab1Component {

    val text: CStateFlow<StringDesc>

    fun onExitClick()

    sealed interface Output {
        object ExitRequested : Output
    }
}