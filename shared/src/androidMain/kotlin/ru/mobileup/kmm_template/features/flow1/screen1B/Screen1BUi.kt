package ru.mobileup.kmm_template.features.flow1.screen1B

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import dev.icerock.moko.resources.compose.localized
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.widget.Toolbar
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.FakeScreen1BComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.Screen1BComponent

@Composable
fun Screen1BUi(
    component: Screen1BComponent,
    modifier: Modifier = Modifier
) {
    val text by component.title.collectAsState()

    Column(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Toolbar(title = text.localized())

        Button(
            modifier = Modifier.padding(top = 48.dp),
            onClick = component::onNextClick
        ) {
            Text(text = stringResource(MR.strings.common_next))
        }
    }
}

@Preview(showSystemUi = true)
@Composable
fun Screen1BUiPreview() {
    AppTheme {
        Screen1BUi(FakeScreen1BComponent())
    }
}