package ru.mobileup.kmm_template.features.home.tab2

import androidx.compose.foundation.layout.Arrangement
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
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.core.widget.button.AppButton
import ru.mobileup.kmm_template.core.widget.button.ButtonType

@Composable
fun Tab2Ui(
    component: Tab2Component,
    modifier: Modifier = Modifier
) {
    val text by component.text.collectAsState()

    Column(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {

        Text(
            text = text.localized(),
            style = CustomTheme.typography.title.regular
        )

        AppButton(
            text = stringResource(MR.strings.home_tab2_start_flow2_button),
            onClick = component::onStartFlow2Click,
            buttonType = ButtonType.Primary
        )
    }
}

@Preview(showSystemUi = true)
@Composable
fun Tab2UiPreview() {
    AppTheme {
        Tab2Ui(FakeTab2Component())
    }
}