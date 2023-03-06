package ru.mobileup.kmm_template.core

import co.touchlab.kermit.Logger
import co.touchlab.kermit.Severity
import com.arkivanov.decompose.ComponentContext
import org.koin.core.Koin
import ru.mobileup.kmm_template.core.configuration.BuildType
import ru.mobileup.kmm_template.core.configuration.Configuration
import ru.mobileup.kmm_template.features.allFeatureModules
import ru.mobileup.kmm_template.features.root.createRootComponent
import ru.mobileup.kmm_template.features.root.ui.RootComponent

class Core(configuration: Configuration) {

    private val koin: Koin

    init {
        if (configuration.buildType == BuildType.Release) {
            Logger.setMinSeverity(Severity.Assert)
        }
        koin = createKoin(configuration)
    }

    fun createRootComponent(
        componentContext: ComponentContext
    ): RootComponent {
        return koin.get<ComponentFactory>().createRootComponent(componentContext)
    }

    internal inline fun <reified T : Any> get(): T = koin.get<T>()

    private fun createKoin(configuration: Configuration): Koin {
        return Koin().apply {
            loadModules(
                listOf(
                    commonCoreModule(configuration),
                    platformCoreModule(configuration),
                ) + allFeatureModules
            )
            declare(ComponentFactory(this))
            createEagerInstances()
        }
    }
}

interface CoreProvider {
    val core: Core
}