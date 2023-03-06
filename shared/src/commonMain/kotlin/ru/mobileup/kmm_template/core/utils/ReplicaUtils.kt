package ru.mobileup.kmm_template.core.utils

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.StringDesc
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import me.aartikov.replica.decompose.observe
import me.aartikov.replica.keyed.KeyedReplica
import me.aartikov.replica.single.Loadable
import me.aartikov.replica.single.Replica
import me.aartikov.replica.single.currentState
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.error_handling.errorMessage
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.computed

/**
 * An analogue of [Loadable] but with localized error message. Required for Swift interop.
 */
data class LoadableState<T : Any>(
    val loading: Boolean = false,
    val data: T? = null,
    val error: StringDesc? = null
)

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

    return componentContext.computed(observer.stateFlow) {
        LoadableState(it.loading, it.data, it.error?.exception?.errorMessage)
    }
}

/**
 * Observes [KeyedReplica] and handles errors by [ErrorHandler].
 */
fun <T : Any, K : Any> KeyedReplica<K, T>.observe(
    componentContext: ComponentContext,
    errorHandler: ErrorHandler,
    key: StateFlow<K?>
): CStateFlow<LoadableState<T>> {

    val observer = observe(componentContext.lifecycle, key)

    observer
        .loadingErrorFlow
        .onEach { error ->
            errorHandler.handleError(
                error.exception,
                showError = observer.currentState.data != null // show error only if fullscreen error is not shown
            )
        }
        .launchIn(componentContext.componentScope)

    return componentContext.computed(observer.stateFlow) {
        LoadableState(it.loading, it.data, it.error?.exception?.errorMessage)
    }
}

fun <T : Any, R : Any> CStateFlow<LoadableState<T>>.mapData(
    componentContext: ComponentContext,
    transform: (T) -> R
): CStateFlow<LoadableState<R>> {
    return componentContext.computed(this) { value ->
        value.mapData { transform(it) }
    }
}

fun <T : Any, R : Any> LoadableState<T>.mapData(
    transform: (T) -> R
): LoadableState<R> {
    return LoadableState(loading, data?.let { transform(it) }, error)
}
