package ru.mobileup.kmm_template.features.flow2.screen2B

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
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
import ru.mobileup.kmm_template.features.flow2.presentation.screen2B.FakeScreen2BComponent
import ru.mobileup.kmm_template.features.flow2.presentation.screen2B.Screen2BComponent

@Composable
fun Screen2BUi(
    component: Screen2BComponent,
    modifier: Modifier = Modifier
) {
    val text by component.text.collectAsState()

    Column(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Toolbar(title = text.localized())

        AppButton(
            text = stringResource(MR.strings.common_next),
            onClick = component::onNextClick,
            buttonType = ButtonType.Primary
        )
    }
}

@Preview(showSystemUi = true)
@Composable
private fun Screen2BUiPreview() {
    AppTheme {
        Screen2BUi(FakeScreen2BComponent())
    }
}