package ${packageName}.features.${path}

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import com.arkivanov.decompose.ComponentContext
import com.arkivanov.decompose.router.stack.StackNavigation
import ru.mobileup.kmm_template.core.utils.toCStateFlow
import com.arkivanov.decompose.router.stack.childStack
import ru.mobileup.kmm_template.core.state.CStateFlow
import com.arkivanov.decompose.router.stack.ChildStack

class Real${componentName}(
    componentContext: ComponentContext,
    <#if output == true>
    private val onOutput: (${componentName}.Output) -> Unit,
    </#if>
) : ComponentContext by componentContext, ${componentName} {

    private val navigation = StackNavigation<ChildConfig>()

    override val childStack: StateFlow<ChildStack<*, ${componentName}.Child>> = childStack(
        source = navigation,
        initialConfiguration = ChildConfig.Default,
        serializer = ChildConfig.serializer(),
        handleBackButton = true,
        childFactory = ::createChild
    ).toStateFlow(lifecycle)


    private fun createChild(
        config: ChildConfig,
        componentContext: ComponentContext
    ): ${componentName}.Child = when (config) {
        ChildConfig.Default -> ${componentName}.Child.Default
    }

    sealed interface ChildConfig : Parcelable {

        @Serializable
        object Default : ChildConfig
    }

}