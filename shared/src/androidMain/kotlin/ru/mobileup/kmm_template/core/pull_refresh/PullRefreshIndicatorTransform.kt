package ru.mobileup.kmm_template.core.pull_refresh

import androidx.compose.animation.core.LinearOutSlowInEasing
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.graphics.drawscope.clipRect
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.debugInspectorInfo
import androidx.compose.ui.platform.inspectable

// TODO: Consider whether the state parameter should be replaced with lambdas.
@ExperimentalMaterial3Api
fun Modifier.pullRefreshIndicatorTransform(
    state: PullRefreshState,
    scale: Boolean = false,
) = inspectable(inspectorInfo = debugInspectorInfo {
    name = "pullRefreshIndicatorTransform"
    properties["state"] = state
    properties["scale"] = scale
}) {
    Modifier
        // Essentially we only want to clip the at the top, so the indicator will not appear when
        // the position is 0. It is preferable to clip the indicator as opposed to the layout that
        // contains the indicator, as this would also end up clipping shadows drawn by items in a
        // list for example - so we leave the clipping to the scrolling container. We use MAX_VALUE
        // for the other dimensions to allow for more room for elevation / arbitrary indicators - we
        // only ever really want to clip at the top edge.
        .drawWithContent {
            clipRect(
                top = 0f,
                left = -Float.MAX_VALUE,
                right = Float.MAX_VALUE,
                bottom = Float.MAX_VALUE
            ) {
                this@drawWithContent.drawContent()
            }
        }
        .graphicsLayer {
            translationY = state.position - size.height

            if (scale && !state.refreshing) {
                val scaleFraction = LinearOutSlowInEasing
                    .transform(state.position / state.threshold)
                    .coerceIn(0f, 1f)
                scaleX = scaleFraction
                scaleY = scaleFraction
            }
        }
}