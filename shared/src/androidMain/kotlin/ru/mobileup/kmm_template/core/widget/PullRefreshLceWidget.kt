package ru.mobileup.kmm_template.core.widget

import androidx.compose.foundation.layout.Box
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import ru.mobileup.kmm_template.core.utils.AbstractLoadableState
import ru.mobileup.kmm_template.core.pull_refresh.PullRefreshIndicator
import ru.mobileup.kmm_template.core.pull_refresh.pullRefresh
import ru.mobileup.kmm_template.core.pull_refresh.rememberPullRefreshState
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme

/**
 * Displays Replica state ([AbstractLoadableState]) with pull-to-refresh functionality.
 *
 * Note: a value of refreshing in [content] is true only when data is refreshing and pull gesture didn't occur.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun <T : Any> PullRefreshLceWidget(
    state: AbstractLoadableState<T>,
    onRefresh: () -> Unit,
    onRetryClick: () -> Unit,
    modifier: Modifier = Modifier,
    content: @Composable (data: T, refreshing: Boolean) -> Unit
) {
    LceWidget(
        state = state,
        onRetryClick = onRetryClick,
        modifier = modifier
    ) { data, refreshing ->
        var pullGestureOccurred by remember { mutableStateOf(false) }

        LaunchedEffect(refreshing) {
            if (!refreshing) pullGestureOccurred = false
        }

        val pullRefreshState = rememberPullRefreshState(
            refreshing = pullGestureOccurred && refreshing,
            onRefresh = {
                pullGestureOccurred = true
                onRefresh()
            }
        )

        Box(
            modifier = Modifier.pullRefresh(pullRefreshState)
        ) {
            content(
                data,
                refreshing && !pullGestureOccurred
            )

            PullRefreshIndicator(
                modifier = Modifier.align(Alignment.TopCenter),
                refreshing = pullGestureOccurred && refreshing,
                state = pullRefreshState,
                contentColor = CustomTheme.colors.icon.primary
            )
        }
    }
}