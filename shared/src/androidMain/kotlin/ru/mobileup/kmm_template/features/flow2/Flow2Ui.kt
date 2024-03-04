package ru.mobileup.kmm_template.features.flow2

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.arkivanov.decompose.extensions.compose.jetpack.stack.Children
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.features.flow2.screen2A.Screen2AUi
import ru.mobileup.kmm_template.features.flow2.screen2B.Screen2BUi
import ru.mobileup.kmm_template.features.flow2.screen2C.Screen2CUi
import ru.mobileup.kmm_template.features.flow2.presentation.FakeFlow2Component
import ru.mobileup.kmm_template.features.flow2.presentation.Flow2Component

@Composable
fun Flow2Ui(
    component: Flow2Component,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    Children(childStack, modifier) { child ->
        when (val instance = child.instance) {
            is Flow2Component.Child.Screen2A -> Screen2AUi(instance.component)
            is Flow2Component.Child.Screen2B -> Screen2BUi(instance.component)
            is Flow2Component.Child.Screen2C -> Screen2CUi(instance.component)
        }
    }
}

@Preview(showSystemUi = true)
@Composable
fun Flow2UiPreview() {
    AppTheme {
        Flow2Ui(FakeFlow2Component())
    }
}