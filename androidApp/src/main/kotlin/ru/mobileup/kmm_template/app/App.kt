package ru.mobileup.kmm_template.app

import android.app.Application
import ru.mobileup.kmm_template.core.Core
import ru.mobileup.kmm_template.core.CoreProvider
import ru.mobileup.kmm_template.core.configuration.Backend
import ru.mobileup.kmm_template.core.configuration.BuildType
import ru.mobileup.kmm_template.core.configuration.Configuration
import ru.mobileup.kmm_template.core.configuration.Platform
import ru.mobileup.kmm_template.core.launchAndroidDebugTools

class App : Application(), CoreProvider {

    override lateinit var core: Core
        private set

    override fun onCreate() {
        super.onCreate()
        core = Core(getConfiguration())
        core.launchAndroidDebugTools()
    }

    @Suppress("SENSELESS_COMPARISON")
    private fun getConfiguration() = Configuration(
        platform = Platform(this, RealAndroidDebugTools(applicationContext)),
        buildType = if (BuildConfig.DEBUG) BuildType.Debug else BuildType.Release,
        backend = if (BuildConfig.FLAVOR == "dev") Backend.Development else Backend.Production
    )
}