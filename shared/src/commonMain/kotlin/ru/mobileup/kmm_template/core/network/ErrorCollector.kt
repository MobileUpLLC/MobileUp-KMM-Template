package ru.mobileup.kmm_template.core.network

import ru.mobileup.kmm_template.core.error_handling.ApplicationException

fun interface ErrorCollector {
    fun collectNetworkError(exception: ApplicationException)
}