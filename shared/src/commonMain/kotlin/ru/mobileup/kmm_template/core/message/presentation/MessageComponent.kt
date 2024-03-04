package ru.mobileup.kmm_template.core.message.presentation

import ru.mobileup.kmm_template.core.message.domain.Message
import ru.mobileup.kmm_template.core.state.CNullableStateFlow

/**
 * A component for centralized message showing. There should be only one instance
 * of this component in the app connected to the root component.
 */
interface MessageComponent {

    val visibleMessage: CNullableStateFlow<Message>

    fun onActionClick()
}