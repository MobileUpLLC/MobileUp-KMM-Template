package ru.mobileup.kmm_template.core.state

import kotlinx.coroutines.flow.StateFlow

/**
 * A wrapper for [StateFlow] with nullable value. Required for Swift interop.
 */
open class CNullableStateFlow<T : Any>(private val stateFlow: StateFlow<T?>) :
    StateFlow<T?> by stateFlow

fun <T : Any> StateFlow<T?>.toCNullableStateFlow() = CNullableStateFlow(this)