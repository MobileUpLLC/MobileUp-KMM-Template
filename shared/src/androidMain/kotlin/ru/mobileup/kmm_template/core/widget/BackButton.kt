package ru.mobileup.kmm_template.core.widget

import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import ru.mobileup.kmm_template.core.utils.dispatchOnBackPressed

@Composable
fun BackButton(
    modifier: Modifier = Modifier,
    imageVector: ImageVector = Icons.Filled.ArrowBack,
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