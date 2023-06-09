package ru.flawery.core.state

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow

/**
 * A wrapper for [Flow]. Required for Swift interop.
 */
open class CFlow<T : Any>(private val flow: Flow<T>) : Flow<T> by flow

fun <T : Any> Flow<T>.toCFlow() = CFlow(this)

fun <T : Any> emptyCFlow() = emptyFlow<T>().toCFlow()