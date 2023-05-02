package ru.mobileup.kmm_template.core.utils

import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp

/**
 * Created by VITTACH on 09.03.2023.
 */
val LocalEdgeToEdgeSettings =
    staticCompositionLocalOf { mutableStateMapOf<Int, EdgeToEdgeSettings>() }

data class EdgeToEdgeSettings(
    val transparentStatusBar: Boolean,
    val transparentNavigationBar: Boolean
)

@Composable
fun EdgeToEdge(transparentStatusBar: Boolean, transparentNavigationBar: Boolean) {
    val key = currentCompositeKeyHash
    val edgeToEdgeSettings = EdgeToEdgeSettings(transparentStatusBar, transparentNavigationBar)
    val edgeToEdgeSettingsMap = LocalEdgeToEdgeSettings.current

    DisposableEffect(edgeToEdgeSettings) {
        edgeToEdgeSettingsMap[key] = edgeToEdgeSettings
        onDispose { edgeToEdgeSettingsMap.remove(key) }
    }
}

@Composable
fun Map<Int, EdgeToEdgeSettings>.accumulate(): EdgeToEdgeSettings {
    return EdgeToEdgeSettings(
        transparentStatusBar = values.any { it.transparentStatusBar },
        transparentNavigationBar = values.any { it.transparentNavigationBar }
    )
}

fun Modifier.edgeToEdgePaddings(): Modifier = composed {
    val edgeToEdgeSettings = LocalEdgeToEdgeSettings.current.accumulate()
    val systemBarsPadding = WindowInsets.systemBars.asPaddingValues()
    val statusBarHeight = systemBarsPadding.calculateTopPadding()
    val navigationBarHeight = systemBarsPadding.calculateBottomPadding()
    val isKeyboardOpen by keyboardAsState()

    padding(
        top = if (edgeToEdgeSettings.transparentStatusBar) {
            0.dp
        } else {
            statusBarHeight
        },
        bottom = if (edgeToEdgeSettings.transparentNavigationBar || isKeyboardOpen) {
            0.dp
        } else {
            navigationBarHeight
        }
    ).then(Modifier.imePadding())
}

@Composable
fun keyboardAsState(): State<Boolean> {
    val isImeVisible = WindowInsets.ime.getBottom(LocalDensity.current) > 0
    return rememberUpdatedState(isImeVisible)
}
