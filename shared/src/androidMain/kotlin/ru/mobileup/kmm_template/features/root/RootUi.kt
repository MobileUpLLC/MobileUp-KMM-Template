package ru.mobileup.kmm_template.features.root

import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.arkivanov.decompose.extensions.compose.stack.Children
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import ru.mobileup.kmm_template.core.message.ui.MessageUi
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.core.utils.ConfigureSystemBars
import ru.mobileup.kmm_template.core.utils.LocalSystemBarsSettings
import ru.mobileup.kmm_template.core.utils.accumulate
import ru.mobileup.kmm_template.features.flow1.Flow1Ui
import ru.mobileup.kmm_template.features.flow2.Flow2Ui
import ru.mobileup.kmm_template.features.home.HomeUi
import ru.mobileup.kmm_template.features.root.presentation.FakeRootComponent
import ru.mobileup.kmm_template.features.root.presentation.RootComponent

@Composable
fun RootUi(
    component: RootComponent,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()
    val systemBarsSettings = LocalSystemBarsSettings.current.accumulate()

    Children(childStack, modifier) { child ->
        when (val instance = child.instance) {
            is RootComponent.Child.Flow1 -> Flow1Ui(instance.component)
            is RootComponent.Child.Home -> HomeUi(instance.component)
            is RootComponent.Child.Flow2 -> Flow2Ui(instance.component)
        }
    }

    MessageUi(
        component = component.messageComponent,
        modifier = modifier,
        bottomPadding = 16.dp
    )

    ConfigureSystemBars(systemBarsSettings)
}

@Preview(showSystemUi = true)
@Composable
fun RootUiPreview() {
    AppTheme {
        RootUi(FakeRootComponent())
    }
}