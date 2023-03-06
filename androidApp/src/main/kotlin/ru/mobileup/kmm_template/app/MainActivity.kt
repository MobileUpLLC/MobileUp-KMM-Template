package ru.mobileup.kmm_template.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import com.arkivanov.decompose.defaultComponentContext
import com.arkivanov.essenty.lifecycle.asEssentyLifecycle
import com.arkivanov.essenty.lifecycle.doOnDestroy
import ru.mobileup.kmm_template.core.activityProvider
import ru.mobileup.kmm_template.core.core
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.features.root.RootUi

// Note: rootComponent survives configuration changes due to "android:configChanges" setting in the manifest.
class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)

        val activityProvider = application.core.activityProvider
        activityProvider.attachActivity(this)
        lifecycle.asEssentyLifecycle().doOnDestroy {
            activityProvider.detachActivity()
        }

        val rootComponent = application.core.createRootComponent(defaultComponentContext())
        setContent {
            AppTheme {
                RootUi(rootComponent)
            }
        }
    }
}