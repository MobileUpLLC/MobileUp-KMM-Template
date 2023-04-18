package ru.mobileup.kmm_template.features.flow1

import com.arkivanov.decompose.ComponentContext
import org.koin.core.component.get
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.features.flow1.ui.Flow1Component
import ru.mobileup.kmm_template.features.flow1.ui.RealFlow1Component
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.RealScreen1AComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.Screen1AComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1B.RealScreen1BComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1B.Screen1BComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1C.RealScreen1CComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1C.Screen1CComponent

fun ComponentFactory.createFlow1Component(
    componentContext: ComponentContext,
    onOutput: (Flow1Component.Output) -> Unit
): Flow1Component {
    return RealFlow1Component(componentContext, onOutput, get())
}

fun ComponentFactory.createScreen1AComponent(
    componentContext: ComponentContext,
    onOutput: (Screen1AComponent.Output) -> Unit
): Screen1AComponent {
    return RealScreen1AComponent(componentContext, onOutput)
}

fun ComponentFactory.createScreen1BComponent(
    componentContext: ComponentContext,
    onOutput: (Screen1BComponent.Output) -> Unit
): Screen1BComponent {
    return RealScreen1BComponent(componentContext, onOutput)
}

fun ComponentFactory.createScreen1CComponent(
    componentContext: ComponentContext,
    onOutput: (Screen1CComponent.Output) -> Unit
): Screen1CComponent {
    return RealScreen1CComponent(componentContext, onOutput)
}