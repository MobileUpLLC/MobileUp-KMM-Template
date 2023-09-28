package ${packageName}.features.${path}

import com.arkivanov.decompose.router.stack.ChildStack
import ru.mobileup.kmm_template.core.state.CStateFlow

interface ${componentName} {

    val childStack: CStateFlow<ChildStack<*, Child>>

    sealed interface Child {
        object Default : Child
    }
<#if output == true>

        sealed interface Output {

        }
</#if>
}