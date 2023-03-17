package ru.mobileup.kmm_template.features.flow2

import com.arkivanov.decompose.ComponentContext
import org.koin.core.component.get
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.features.flow2.ui.Flow2Component
import ru.mobileup.kmm_template.features.flow2.ui.RealFlow2Component
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.RealScreen2AComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.Screen2AComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2B.RealScreen2BComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2B.Screen2BComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2C.RealScreen2CComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2C.Screen2CComponent

fun ComponentFactory.createFlow2Component(
    componentContext: ComponentContext,
    onOutput: (Flow2Component.Output) -> Unit
): Flow2Component {
    return RealFlow2Component(componentContext, onOutput, get())
}

fun ComponentFactory.createScreen2AComponent(
    componentContext: ComponentContext,
    onOutput: (Screen2AComponent.Output) -> Unit
): Screen2AComponent {
    return RealScreen2AComponent(componentContext, onOutput)
}

fun ComponentFactory.createScreen2BComponent(
    componentContext: ComponentContext,
    onOutput: (Screen2BComponent.Output) -> Unit
): Screen2BComponent {
    return RealScreen2BComponent(componentContext, onOutput)
}

fun ComponentFactory.createScreen2CComponent(
    componentContext: ComponentContext,
    onOutput: (Screen2CComponent.Output) -> Unit
): Screen2CComponent {
    return RealScreen2CComponent(componentContext, onOutput)
}