package ru.mobileup.kmm_template.features.flow1.screen1A

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
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.FakeScreen1AComponent
import ru.mobileup.kmm_template.features.flow1.ui.screen1A.Screen1AComponent

@Composable
fun Screen1AUi(
    component: Screen1AComponent,
    modifier: Modifier = Modifier
) {
    val text by component.title.collectAsState()

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
fun Screen1AUiPreview() {
    AppTheme {
        Screen1AUi(FakeScreen1AComponent())
    }
}