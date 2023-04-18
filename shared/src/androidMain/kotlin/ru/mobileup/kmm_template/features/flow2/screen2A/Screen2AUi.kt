package ru.mobileup.kmm_template.features.flow2.screen2A

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
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
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.FakeScreen2AComponent
import ru.mobileup.kmm_template.features.flow2.ui.screen2A.Screen2AComponent

@Composable
fun Screen2AUi(
    component: Screen2AComponent,
    modifier: Modifier = Modifier
) {
    val text by component.text.collectAsState()

    Column(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Toolbar(
            title = text.localized(),
            navigationIcon = Icons.Filled.Close
        )

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
fun Screen2AUiPreview() {
    AppTheme {
        Screen2AUi(FakeScreen2AComponent())
    }
}