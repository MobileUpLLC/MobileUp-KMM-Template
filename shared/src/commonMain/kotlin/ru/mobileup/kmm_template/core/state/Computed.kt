package ru.mobileup.kmm_template.core.state

import com.arkivanov.decompose.ComponentContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.dropWhile
import kotlinx.coroutines.launch
import ru.mobileup.kmm_template.core.utils.componentScope

fun <T, R : Any> ComponentContext.computed(
    flow: StateFlow<T>,
    transform: (T) -> R
): CStateFlow<R> {
    val initialValue = flow.value
    val resultFlow = CMutableStateFlow(transform(initialValue))
    componentScope.launch {
        flow.dropWhile {
            it == initialValue
        }
            .collect {
                resultFlow.value = transform(it)
            }
    }
    return resultFlow
}

@Suppress("UNCHECKED_CAST")
fun <T1, T2, R : Any> ComponentContext.computed(
    flow1: StateFlow<T1>,
    flow2: StateFlow<T2>,
    transform: (T1, T2) -> R
): CStateFlow<R> {
    return computedImpls(flow1, flow2) { args: List<*> ->
        transform(
            args[0] as T1,
            args[1] as T2
        )
    }
}

@Suppress("UNCHECKED_CAST")
fun <T1, T2, T3, R : Any> ComponentContext.computed(
    flow1: StateFlow<T1>,
    flow2: StateFlow<T2>,
    flow3: StateFlow<T3>,
    transform: (T1, T2, T3) -> R
): CStateFlow<R> {
    return computedImpls(flow1, flow2, flow3) { args: List<*> ->
        transform(
            args[0] as T1,
            args[1] as T2,
            args[2] as T3
        )
    }
}

@Suppress("UNCHECKED_CAST")
fun <T1, T2, T3, T4, R : Any> ComponentContext.computed(
    flow1: StateFlow<T1>,
    flow2: StateFlow<T2>,
    flow3: StateFlow<T3>,
    flow4: StateFlow<T4>,
    transform: (T1, T2, T3, T4) -> R
): CStateFlow<R> {
    return computedImpls(flow1, flow2, flow3, flow4) { args: List<*> ->
        transform(
            args[0] as T1,
            args[1] as T2,
            args[2] as T3,
            args[3] as T4
        )
    }
}

@Suppress("UNCHECKED_CAST")
fun <T1, T2, T3, T4, T5, R : Any> ComponentContext.computed(
    flow1: StateFlow<T1>,
    flow2: StateFlow<T2>,
    flow3: StateFlow<T3>,
    flow4: StateFlow<T4>,
    flow5: StateFlow<T5>,
    transform: (T1, T2, T3, T4, T5) -> R
): CStateFlow<R> {
    return computedImpls(flow1, flow2, flow3, flow4, flow5) { args: List<*> ->
        transform(
            args[0] as T1,
            args[1] as T2,
            args[2] as T3,
            args[3] as T4,
            args[4] as T5
        )
    }
}

private inline fun <T, R : Any> ComponentContext.computedImpls(
    vararg flows: StateFlow<T>,
    crossinline transform: (List<T>) -> R
): CStateFlow<R> {
    val initialValues = flows.map { it.value }
    val elementsFlow = MutableStateFlow(initialValues)
    val resultFlow = CMutableStateFlow(transform(initialValues))

    flows.forEachIndexed { index, flow ->
        componentScope.launch {
            flow
                .dropWhile {
                    it == initialValues[index]
                }
                .collect {
                    elementsFlow.value =
                        elementsFlow.value.toMutableList().apply { this[index] = it }
                }
        }
    }

    componentScope.launch {
        elementsFlow
            .dropWhile {
                it == initialValues
            }
            .collect {
                resultFlow.value = transform(it)
            }
    }

    return resultFlow
}