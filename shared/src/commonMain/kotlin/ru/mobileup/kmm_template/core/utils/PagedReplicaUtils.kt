package ru.mobileup.kmm_template.core.utils

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import me.aartikov.replica.decompose.observe
import me.aartikov.replica.paged.Paged
import me.aartikov.replica.paged.PagedLoadingStatus
import me.aartikov.replica.paged.PagedReplica
import me.aartikov.replica.paged.currentState
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.error_handling.errorMessage

/**
 * An analogue of [Paged] but with localized error message.
 */
data class PagedState<T : Any>(
    val loadingStatus: PagedLoadingStatus = PagedLoadingStatus.None,
    override val data: T? = null,
    override val error: StringDesc? = null
) : AbstractLoadableState<T> {

    override val loading: Boolean
        get() = loadingStatus == PagedLoadingStatus.LoadingFirstPage
}

/**
 * Observes [PagedReplica] and handles errors by [ErrorHandler].
 */
fun <T : Any> PagedReplica<T>.observe(
    componentContext: ComponentContext,
    errorHandler: ErrorHandler
): StateFlow<PagedState<T>> {
    val observer = observe(componentContext.lifecycle)

    observer
        .loadingErrorFlow
        .onEach { error ->
            errorHandler.handleError(
                error.exception,
                showError = observer.currentState.data != null // show error only if fullscreen error is not shown
            )
        }
        .launchIn(componentContext.componentScope)

    val stateFlow = MutableStateFlow(observer.stateFlow.value.toPagedState())
    observer
        .stateFlow
        .onEach {
            stateFlow.value = it.toPagedState()
        }
        .launchIn(componentContext.componentScope)

    return stateFlow
}

fun <T : Any> Paged<T>.toPagedState(): PagedState<T> {
    return PagedState(
        loadingStatus = loadingStatus,
        data = data,
        error = error?.exception?.errorMessage
    )
}