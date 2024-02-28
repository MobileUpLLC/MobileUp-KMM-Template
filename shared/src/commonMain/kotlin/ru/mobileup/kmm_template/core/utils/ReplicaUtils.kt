package ru.mobileup.kmm_template.core.utils

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import me.aartikov.replica.decompose.observe
import me.aartikov.replica.single.Loadable
import me.aartikov.replica.single.Replica
import me.aartikov.replica.single.currentState
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.error_handling.errorMessage
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.computed

/**
 * Common interface for [LoadableState] and [PagedState]
 */
interface AbstractLoadableState<out T : Any> {

    val loading: Boolean

    val data: T?

    val error: StringDesc?
}

/**
 * An analogue of [Loadable] but with localized error message.
 */
data class LoadableState<T : Any>(
    override val loading: Boolean = false,
    override val data: T? = null,
    override val error: StringDesc? = null
) : AbstractLoadableState<T>

/**
 * Observes [Replica] and handles errors by [ErrorHandler].
 */
fun <T : Any> Replica<T>.observe(
    componentContext: ComponentContext,
    errorHandler: ErrorHandler
): CStateFlow<LoadableState<T>> {
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

    val stateFlow = CMutableStateFlow(observer.stateFlow.value.toLoadableState())
    observer
        .stateFlow
        .onEach {
            stateFlow.value = it.toLoadableState()
        }
        .launchIn(componentContext.componentScope)

    return stateFlow
}

fun <T : Any> Loadable<T>.toLoadableState(): LoadableState<T> {
    return LoadableState(
        loading = loading,
        data = data,
        error = error?.exception?.errorMessage
    )
}

fun <T : Any, R : Any> StateFlow<LoadableState<T>>.mapData(
    componentContext: ComponentContext,
    transform: (T) -> R?
): CStateFlow<LoadableState<R>> {
    return componentContext.computed(this) { value ->
        value.mapData { transform(it) }
    }
}

fun <T : Any, R : Any> LoadableState<T>.mapData(
    transform: (T) -> R?
): LoadableState<R> {
    return LoadableState(loading, data?.let { transform(it) }, error)
}