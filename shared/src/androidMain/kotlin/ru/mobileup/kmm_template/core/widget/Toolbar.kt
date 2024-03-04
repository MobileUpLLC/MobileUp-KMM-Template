package ru.mobileup.kmm_template.core.widget

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Toolbar(
    title: String,
    modifier: Modifier = Modifier,
    navigationIcon: ImageVector = Icons.AutoMirrored.Filled.ArrowBack,
    onNavigationClick: (() -> Unit)? = null
) {
    TopAppBar(
        modifier = modifier,
        title = {
            Text(
                text = title,
                style = CustomTheme.typography.title.regular
            )
        },
        navigationIcon = {
            BackButton(imageVector = navigationIcon, onClick = onNavigationClick)
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = CustomTheme.colors.background.screen
        )
    )
}