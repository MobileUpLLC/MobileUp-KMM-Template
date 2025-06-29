package ${packageName}.features.${path}

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.state.CStateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack

class Fake${componentName} : ${componentName} {

    override val childStack: StateFlow<ChildStack<*, ${componentName}.Child>> =
        createFakeChildStack(${componentName}.Child.Default)
}