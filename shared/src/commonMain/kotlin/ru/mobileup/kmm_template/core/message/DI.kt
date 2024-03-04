package ru.mobileup.kmm_template.core.message

import com.arkivanov.decompose.ComponentContext
import org.koin.core.component.get
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.core.message.presentation.MessageComponent
import ru.mobileup.kmm_template.core.message.presentation.RealMessageComponent

fun ComponentFactory.createMessageComponent(
    componentContext: ComponentContext
): MessageComponent {
    return RealMessageComponent(componentContext, get())
}