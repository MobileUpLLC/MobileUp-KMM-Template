package ru.mobileup.kmm_template.features.root

import androidx.compose.material.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.arkivanov.decompose.extensions.compose.jetpack.stack.Children
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import ru.mobileup.kmm_template.core.message.ui.MessageUi
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.features.flow1.Flow1Ui
import ru.mobileup.kmm_template.features.flow2.Flow2Ui
import ru.mobileup.kmm_template.features.home.HomeUi
import ru.mobileup.kmm_template.features.root.ui.FakeRootComponent
import ru.mobileup.kmm_template.features.root.ui.RootComponent

@Composable
fun RootUi(
    component: RootComponent,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    SystemBarColors()

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
}

@Composable
private fun SystemBarColors() {
    val systemUiController = rememberSystemUiController()

    val statusBarColor = MaterialTheme.colors.surface
    LaunchedEffect(statusBarColor) {
        systemUiController.setStatusBarColor(statusBarColor)
    }

    val navigationBarColor = MaterialTheme.colors.surface
    LaunchedEffect(navigationBarColor) {
        systemUiController.setNavigationBarColor(navigationBarColor)
    }
}

@Preview(showSystemUi = true)
@Composable
fun RootUiPreview() {
    AppTheme {
        RootUi(FakeRootComponent())
    }
}