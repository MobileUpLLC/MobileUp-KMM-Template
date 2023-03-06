package ru.mobileup.kmm_template.core.network

import io.ktor.client.engine.*
import io.ktor.client.engine.okhttp.*
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools

fun createOkHttpEngine(debugTools: AndroidDebugTools): HttpClientEngine {
    return OkHttp.create {
        debugTools.interceptors.forEach { addInterceptor(it) }
    }
}