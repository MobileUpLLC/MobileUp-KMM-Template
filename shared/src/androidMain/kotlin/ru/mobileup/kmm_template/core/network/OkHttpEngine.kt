package ru.mobileup.kmm_template.core.network

import io.ktor.client.engine.HttpClientEngine
import io.ktor.client.engine.okhttp.OkHttp
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools

fun createOkHttpEngine(debugTools: AndroidDebugTools): HttpClientEngine {
    return OkHttp.create {
        debugTools.interceptors.forEach { addInterceptor(it) }
    }
}