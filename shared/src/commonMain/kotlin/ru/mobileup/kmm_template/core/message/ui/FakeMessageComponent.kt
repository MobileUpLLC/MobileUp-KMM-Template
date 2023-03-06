package ru.mobileup.kmm_template.core.message.ui

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.core.message.domain.Message
import ru.mobileup.kmm_template.core.state.CNullableMutableStateFlow

class FakeMessageComponent : MessageComponent {

    override val visibleMessage = CNullableMutableStateFlow(Message(StringDesc.Raw("Message")))

    override fun onActionClick() = Unit
}