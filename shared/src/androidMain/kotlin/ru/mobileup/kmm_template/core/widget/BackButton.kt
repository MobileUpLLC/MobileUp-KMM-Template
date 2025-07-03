package ru.mobileup.kmm_template.core.widget

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import ru.mobileup.kmm_template.core.utils.dispatchOnBackPressed

@Composable
fun BackButton(
    modifier: Modifier = Modifier,
    imageVector: ImageVector = Icons.AutoMirrored.Filled.ArrowBack,
    onClick: (() -> Unit)? = null
) {
    val context = LocalContext.current
    IconButton(
        modifier = modifier,
        onClick = {
            if (onClick != null) {
                onClick()
            } else {
                dispatchOnBackPressed(context)
            }
        }
    ) {
        Icon(imageVector, contentDescription = null)
    }
}