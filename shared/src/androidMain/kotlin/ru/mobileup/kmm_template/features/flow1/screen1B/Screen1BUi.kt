package ru.mobileup.kmm_template.features.flow1.screen1B

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import dev.icerock.moko.resources.compose.localized
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.widget.Toolbar
import ru.mobileup.kmm_template.core.widget.button.AppButton
import ru.mobileup.kmm_template.core.widget.button.ButtonType
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.FakeScreen1BComponent
import ru.mobileup.kmm_template.features.flow1.presentation.screen1B.Screen1BComponent

@Composable
fun Screen1BUi(
    component: Screen1BComponent,
    modifier: Modifier = Modifier
) {
    val text by component.title.collectAsState()

    Scaffold(
        modifier = modifier,
        contentWindowInsets = WindowInsets.systemBars,
        topBar = { Toolbar(title = text.localized()) }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            AppButton(
                text = stringResource(MR.strings.common_next),
                onClick = component::onNextClick,
                buttonType = ButtonType.Primary,
                modifier = Modifier.align(Alignment.Center)
            )
        }
    }
}

@Preview(showSystemUi = true)
@Composable
private fun Screen1BUiPreview() {
    AppTheme {
        Screen1BUi(FakeScreen1BComponent())
    }
}