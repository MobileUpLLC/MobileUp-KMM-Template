package ru.mobileup.kmm_template.core.message.ui

import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.currentCompositeKeyHash
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.layout.findRootCoordinates
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInWindow
import androidx.compose.ui.platform.LocalDensity
import ru.mobileup.kmm_template.core.utils.navigationBarsWithImePaddingDp

val LocalMessageOffsets = staticCompositionLocalOf { mutableStateMapOf<Int, Int>() }

/**
 * Allows to specify that a message (see [MessageUi]) should be displayed above an UI element.
 * For example, set noOverlapByMessage() to a bottom navigation bar, so it will not be overlapped by a message popup.
 */
fun Modifier.noOverlapByMessage(): Modifier = composed {
    val key = currentCompositeKeyHash
    val localMessageOffsets = LocalMessageOffsets.current
    val bottomInset = with(LocalDensity.current) { navigationBarsWithImePaddingDp.toPx() }

    DisposableEffect(Unit) {
        onDispose { localMessageOffsets.remove(key) }
    }

    onGloballyPositioned { layoutCoordinates ->
        if (layoutCoordinates.isAttached) {
            val y = layoutCoordinates.positionInWindow().y
            val rootHeight = layoutCoordinates.findRootCoordinates().size.height
            val offset = (rootHeight - bottomInset - y).toInt().coerceAtLeast(0)
            localMessageOffsets[key] = offset
        }
    }
}