package ru.mobileup.kmm_template.core.message.ui

import com.arkivanov.decompose.ComponentContext
import com.arkivanov.essenty.lifecycle.doOnCreate
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import ru.mobileup.kmm_template.core.message.data.MessageService
import ru.mobileup.kmm_template.core.message.domain.Message
import ru.mobileup.kmm_template.core.state.CNullableMutableStateFlow
import ru.mobileup.kmm_template.core.utils.componentScope

class RealMessageComponent(
    componentContext: ComponentContext,
    private val messageService: MessageService,
) : ComponentContext by componentContext, MessageComponent {

    companion object {
        private const val SHOW_TIME = 4000L
    }

    override var visibleMessage = CNullableMutableStateFlow<Message>(null)

    private var autoDismissJob: Job? = null

    init {
        lifecycle.doOnCreate(::collectMessages)
    }

    override fun onActionClick() {
        autoDismissJob?.cancel()
        visibleMessage.value?.action?.invoke()
        visibleMessage.value = null
    }

    private fun collectMessages() {
        componentScope.launch {
            messageService.messageFlow.collect { messageData ->
                showMessage(messageData)
            }
        }
    }

    private fun showMessage(message: Message) {
        autoDismissJob?.cancel()
        visibleMessage.value = message
        autoDismissJob = componentScope.launch {
            delay(SHOW_TIME)
            visibleMessage.value = null
        }
    }
}