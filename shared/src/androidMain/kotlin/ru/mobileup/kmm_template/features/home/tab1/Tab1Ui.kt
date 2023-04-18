package ru.mobileup.kmm_template.features.home.tab1

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Button
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
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

@Composable
fun Tab1Ui(
    component: Tab1Component,
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
            style = MaterialTheme.typography.h6
        )

        Button(
            modifier = Modifier.padding(top = 48.dp),
            onClick = component::onExitClick
        ) {
            Text(text = stringResource(MR.strings.common_exit))
        }
    }
}


@Preview(showSystemUi = true)
@Composable
fun Tab1UiPreview() {
    AppTheme {
        Tab1Ui(FakeTab1Component())
    }
}