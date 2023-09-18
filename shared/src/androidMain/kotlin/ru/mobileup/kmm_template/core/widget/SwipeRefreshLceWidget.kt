package ru.mobileup.kmm_template.core.widget

import androidx.compose.foundation.layout.Box
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.pullrefresh.PullRefreshIndicator
import androidx.compose.material.pullrefresh.PullRefreshState
import androidx.compose.material.pullrefresh.pullRefresh
import androidx.compose.material.pullrefresh.rememberPullRefreshState
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import ru.mobileup.kmm_template.core.utils.LoadableState

/**
 * Displays Replica state ([LoadableState]) with swipe-to-refresh functionality.
 *
 * Note: a value of refreshing in [content] is true only when data is refreshing and swipe gesture didn't occur.
 */
@OptIn(ExperimentalMaterialApi::class)
@Composable
fun <T : Any> SwipeRefreshLceWidget(
    state: LoadableState<T>,
    onRefresh: () -> Unit,
    onRetryClick: () -> Unit,
    modifier: Modifier = Modifier,
    pullRefreshIndicator: @Composable (state: PullRefreshState, refreshing: Boolean) -> Unit = { s, refreshing ->
        // SwipeRefreshIndicator(s, trigger, contentColor = MaterialTheme.colors.primaryVariant)
        PullRefreshIndicator(refreshing = refreshing, state = s)
    },
    content: @Composable (data: T, refreshing: Boolean) -> Unit
) {
    LceWidget(
        state = state,
        onRetryClick = onRetryClick,
        modifier = modifier
    ) { data, refreshing ->
        var swipeGestureOccurred by remember { mutableStateOf(false) }

        LaunchedEffect(refreshing) {
            if (!refreshing) swipeGestureOccurred = false
        }

        val pullRefreshState = rememberPullRefreshState(
            refreshing = swipeGestureOccurred && refreshing,
            onRefresh = onRefresh
        )

        Box(
            modifier = Modifier
                .pullRefresh(pullRefreshState)
        ) {
            pullRefreshIndicator(
                pullRefreshState,
                swipeGestureOccurred && refreshing
            )
            content(
                data,
                refreshing && !swipeGestureOccurred
            )
        }
    }
}