package ru.mobileup.kmm_template.core.state

import kotlin.reflect.KMutableProperty0

suspend fun withProgress(
    progressProperty: KMutableProperty0<Boolean>,
    block: suspend () -> Unit
) {
    try {
        progressProperty.set(true)
        block()
    } finally {
        progressProperty.set(false)
    }
}