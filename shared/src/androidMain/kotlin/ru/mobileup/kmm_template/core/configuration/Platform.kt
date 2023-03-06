package ru.mobileup.kmm_template.core.configuration

import android.app.Application
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools

actual class Platform(
    val application: Application,
    val debugTools: AndroidDebugTools
) {
    actual val type = PlatformType.Android
}