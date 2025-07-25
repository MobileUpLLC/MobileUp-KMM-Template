package ru.mobileup.kmm_template.features.home.tab1

import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow

interface Tab1Component {

    val text: StateFlow<StringDesc>

    fun onExitClick()

    sealed interface Output {
        object ExitRequested : Output
    }
}