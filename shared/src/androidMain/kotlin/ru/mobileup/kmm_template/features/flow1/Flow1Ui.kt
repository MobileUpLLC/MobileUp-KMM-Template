package ru.mobileup.kmm_template.features.flow1

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.arkivanov.decompose.extensions.compose.jetpack.stack.Children
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.features.flow1.screen1A.Screen1AUi
import ru.mobileup.kmm_template.features.flow1.screen1B.Screen1BUi
import ru.mobileup.kmm_template.features.flow1.screen1C.Screen1CUi
import ru.mobileup.kmm_template.features.flow1.ui.FakeFlow1Component
import ru.mobileup.kmm_template.features.flow1.ui.Flow1Component

@Composable
fun Flow1Ui(
    component: Flow1Component,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    Children(childStack, modifier) { child ->
        when (val instance = child.instance) {
            is Flow1Component.Child.Screen1A -> Screen1AUi(instance.component)
            is Flow1Component.Child.Screen1B -> Screen1BUi(instance.component)
            is Flow1Component.Child.Screen1C -> Screen1CUi(instance.component)
        }
    }
}


@Preview(showSystemUi = true)
@Composable
fun Flow1UiPreview() {
    AppTheme {
        Flow1Ui(FakeFlow1Component())
    }
}