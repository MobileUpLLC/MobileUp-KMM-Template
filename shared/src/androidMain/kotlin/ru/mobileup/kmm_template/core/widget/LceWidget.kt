package ru.mobileup.kmm_template.core.widget

import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import dev.icerock.moko.resources.compose.localized
import ru.mobileup.kmm_template.core.utils.AbstractLoadableState

/**
 * Displays Replica state ([AbstractLoadableState]).
 */
@Composable
fun <T : Any> LceWidget(
    state: AbstractLoadableState<T>,
    onRetryClick: () -> Unit,
    modifier: Modifier = Modifier,
    content: @Composable (data: T, refreshing: Boolean) -> Unit
) {
    val loading = state.loading
    val data = state.data
    val error = state.error

    Box(modifier) {
        when {
            data != null -> content(data, loading)

            loading -> FullscreenCircularProgress()

            error != null -> ErrorPlaceholder(
                errorMessage = error.localized(),
                onRetryClick = onRetryClick
            )
        }
    }
}