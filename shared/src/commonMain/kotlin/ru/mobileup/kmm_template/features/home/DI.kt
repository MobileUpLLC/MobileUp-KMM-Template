package ru.mobileup.kmm_template.features.home

import com.arkivanov.decompose.ComponentContext
import org.koin.core.component.get
import ru.mobileup.kmm_template.core.ComponentFactory
import ru.mobileup.kmm_template.features.home.tab1.RealTab1Component
import ru.mobileup.kmm_template.features.home.tab1.Tab1Component
import ru.mobileup.kmm_template.features.home.tab2.RealTab2Component
import ru.mobileup.kmm_template.features.home.tab2.Tab2Component

fun ComponentFactory.createHomeComponent(
    componentContext: ComponentContext,
    onOutput: (HomeComponent.Output) -> Unit
): HomeComponent {
    return RealHomeComponent(componentContext, onOutput, get())
}

fun ComponentFactory.createTab1Component(
    componentContext: ComponentContext,
    onOutput: (Tab1Component.Output) -> Unit
): Tab1Component {
    return RealTab1Component(componentContext, onOutput)
}

fun ComponentFactory.createTab2Component(
    componentContext: ComponentContext,
    onOutput: (Tab2Component.Output) -> Unit
): Tab2Component {
    return RealTab2Component(componentContext, onOutput)
}