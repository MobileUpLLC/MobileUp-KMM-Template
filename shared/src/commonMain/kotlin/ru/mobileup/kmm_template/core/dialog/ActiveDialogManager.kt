package ru.mobileup.kmm_template.core.dialog

import co.touchlab.kermit.Logger
import com.arkivanov.decompose.ComponentContext
import com.arkivanov.essenty.instancekeeper.getOrCreateSimple
import com.arkivanov.essenty.lifecycle.doOnStart
import com.arkivanov.essenty.lifecycle.doOnStop
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import ru.mobileup.kmm_template.core.utils.componentScope

class ActiveDialogManager(
    private val componentContext: ComponentContext
) {

    private val logger = Logger.withTag("ActiveDialogManager")

    private val mutex = Mutex()

    private val dialogControlStack = MutableStateFlow<List<DialogControlItem>>(emptyList())

    init {
        var previousStack = emptyList<DialogControlItem>()
        dialogControlStack
            .onEach {
                updateDialogs(previousStack, it)
                previousStack = it
            }
            .launchIn(componentContext.componentScope)

        componentContext.lifecycle.doOnStop {
            updateDialogs(previousStack, emptyList())
        }
        componentContext.lifecycle.doOnStart {
            updateDialogs(emptyList(), previousStack)
        }
    }

    private fun updateDialogs(
        previousStack: List<DialogControlItem>,
        newStack: List<DialogControlItem>
    ) {
        val dialogToActivate = newStack.lastOrNull()
        val dialogsToDeactivate = dialogToActivate
            ?.let { previousStack - it }
            ?: previousStack

        logger.d("""
            updateDialogs: stack: ${newStack.map { it.id }}
            dialogsToDeactivate: ${dialogsToDeactivate.map { it.id }}
            dialogToActivate: ${dialogToActivate?.id}
        """.trimIndent())
        dialogsToDeactivate.forEach { it.deactivateChannel.trySend(Unit) }
        dialogToActivate?.activateChannel?.trySend(Unit)
    }

    // return a pair consisting of (activate, deactivate) commands
    fun <C : Any, T : Any> registerDialog(
        key: String,
        dialogControl: DialogControl<C, T>
    ): Pair<Flow<Unit>, Flow<Unit>> {
        val id = DialogControlId(key)
        val activateChannel = Channel<Unit>()
        val deactivateChannel = Channel<Unit>()

        val dialogItem = DialogControlItem(
            id = id,
            activateChannel = activateChannel,
            deactivateChannel = deactivateChannel
        )

        dialogControl
            .dismissedEvent
            .onEach {
                mutex.withLock {
                    dialogControlStack.update { it - dialogItem }
                }
            }
            .launchIn(componentContext.componentScope)

        dialogControl
            .shownEvent
            .onEach {
                mutex.withLock {
                    dialogControlStack.update { it + dialogItem }
                }
            }
            .launchIn(componentContext.componentScope)

        return activateChannel.receiveAsFlow() to deactivateChannel.receiveAsFlow()
    }
}

private class DialogControlItem(
    val id: DialogControlId,
    val activateChannel: Channel<Unit>,
    val deactivateChannel: Channel<Unit>,
)

private data class DialogControlId(
    private val key: String
)

val ComponentContext.activeDialogManager: ActiveDialogManager
    get() {
        return instanceKeeper.getOrCreateSimple(ActiveDialogManagerKey) {
            ActiveDialogManager(this)
        }
    }

private object ActiveDialogManagerKey
