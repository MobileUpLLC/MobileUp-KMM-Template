package ru.mobileup.kmm_template.core

import android.app.Application
import android.content.Context
import me.aartikov.replica.network.AndroidNetworkConnectivityProvider
import me.aartikov.replica.network.NetworkConnectivityProvider
import org.koin.dsl.module
import ru.mobileup.kmm_template.core.activity.ActivityProvider
import ru.mobileup.kmm_template.core.configuration.Configuration
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools
import ru.mobileup.kmm_template.core.network.ErrorCollector
import ru.mobileup.kmm_template.core.network.createOkHttpEngine

actual fun platformCoreModule(configuration: Configuration) = module {
    single { get<Configuration>().platform.application }
    single { get<Configuration>().platform.debugTools }
    single<Context> { get<Application>() }
    single { ActivityProvider() }
    single { createOkHttpEngine(get()) }
    single {
        val debugTools = get<AndroidDebugTools>()
        ErrorCollector {
            debugTools.collectNetworkError(it)
        }
    }
    single<NetworkConnectivityProvider> { AndroidNetworkConnectivityProvider(get()) }
}