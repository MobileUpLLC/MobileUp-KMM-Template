package ru.mobileup.kmm_template.core.utils

import com.arkivanov.decompose.Child
import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.slot.ChildSlot
import com.arkivanov.decompose.router.stack.ChildStack
import com.arkivanov.decompose.value.Value
import com.arkivanov.essenty.instancekeeper.InstanceKeeper
import com.arkivanov.essenty.lifecycle.Lifecycle
import com.arkivanov.essenty.lifecycle.doOnDestroy
import com.arkivanov.essenty.parcelable.Parcelable
import com.arkivanov.essenty.statekeeper.StateKeeperOwner
import com.arkivanov.essenty.statekeeper.consume
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import me.aartikov.replica.decompose.coroutineScope
import ru.mobileup.kmm_template.core.state.CMutableStateFlow
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.state.toCStateFlow

/**
 * Creates a [ChildStack] with a single active component. Should be used to create a stack for UI-preview.
 */
fun <T : Any> createFakeChildStack(instance: T): CStateFlow<ChildStack<*, T>> {
    return CMutableStateFlow(
        ChildStack(
            configuration = "<fake>",
            instance = instance
        )
    )
}

/**
 * Creates a [ChildStack] with a single active component. Should be used to create a stack for UI-preview.
 */
fun <T : Any> createFakeChildStackFlow(instance: T): StateFlow<ChildStack<*, T>> {
    return MutableStateFlow(
        ChildStack(
            configuration = "<fake>",
            instance = instance
        )
    )
}

/**
 * Creates a [ChildSlot] with a single active component. Should be used to create a child slot for UI-preview.
 */
fun <T : Any> createFakeChildSlot(instance: T): CStateFlow<ChildSlot<*, T>> {
    return CMutableStateFlow(
        ChildSlot(
            Child.Created(
                configuration = "<fake>",
                instance = instance
            )
        )
    )
}

/**
 * Converts [Value] from Decompose to [CStateFlow].
 */
fun <T : Any> Value<T>.toCStateFlow(lifecycle: Lifecycle): CStateFlow<T> {
    val stateFlow: MutableStateFlow<T> = MutableStateFlow(this.value)

    if (lifecycle.state != Lifecycle.State.DESTROYED) {
        val observer = { value: T -> stateFlow.value = value }
        subscribe(observer)
        lifecycle.doOnDestroy {
            unsubscribe(observer)
        }
    }

    return stateFlow.toCStateFlow()
}

/**
 * Converts [Value] from Decompose to [StateFlow].
 */
fun <T : Any> Value<T>.toStateFlow(lifecycle: Lifecycle): StateFlow<T> {
    val stateFlow: MutableStateFlow<T> = MutableStateFlow(this.value)

    if (lifecycle.state != Lifecycle.State.DESTROYED) {
        val observer = { value: T -> stateFlow.value = value }
        subscribe(observer)
        lifecycle.doOnDestroy {
            unsubscribe(observer)
        }
    }

    return stateFlow
}

/**
 * Returns a coroutine scope tied to Decompose lifecycle. A scope is canceled when a component is destroyed.
 */
val ComponentContext.componentScope: CoroutineScope
    get() {
        val scope = (instanceKeeper.get(ComponentScopeKey) as? CoroutineScopeWrapper)?.scope
        if (scope != null) return scope

        val newScope = lifecycle.coroutineScope()
        instanceKeeper.put(ComponentScopeKey, CoroutineScopeWrapper(newScope))
        return newScope
    }

private object ComponentScopeKey

private class CoroutineScopeWrapper(val scope: CoroutineScope) : InstanceKeeper.Instance {
    override fun onDestroy() {
        // nothing
    }
}

/**
 * A helper function to save and restore component state.
 */
inline fun <reified T : Parcelable> StateKeeperOwner.persistent(
    key: String = "PersistentState",
    noinline save: () -> T,
    restore: (T) -> Unit
) {
    stateKeeper.consume<T>(key)?.run(restore)
    stateKeeper.register(key, save)
}