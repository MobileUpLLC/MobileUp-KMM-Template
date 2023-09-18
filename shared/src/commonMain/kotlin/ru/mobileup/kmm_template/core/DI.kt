package ru.mobileup.kmm_template.core

import me.aartikov.replica.client.ReplicaClient
import org.koin.core.module.Module
import org.koin.dsl.module
import ru.mobileup.kmm_template.core.configuration.BuildType
import ru.mobileup.kmm_template.core.configuration.Configuration
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.message.data.MessageService
import ru.mobileup.kmm_template.core.message.data.MessageServiceImpl
import ru.mobileup.kmm_template.core.network.BackendUrl
import ru.mobileup.kmm_template.core.network.NetworkApiFactory

fun commonCoreModule(configuration: Configuration) = module {
    single { configuration }
    single { ReplicaClient(getOrNull()) }
    single<MessageService> { MessageServiceImpl() }
    single { ErrorHandler(get()) }
    single {
        NetworkApiFactory(
            loggingEnabled = configuration.buildType == BuildType.Debug,
            backendUrl = BackendUrl.getMainUrl(configuration.backend),
            httpClientEngine = get()
        )
    }
}

expect fun platformCoreModule(configuration: Configuration): Module