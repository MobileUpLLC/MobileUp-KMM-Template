package ru.mobileup.kmm_template.core.theme

import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import ru.mobileup.kmm_template.core.theme.custom.BodyTypography
import ru.mobileup.kmm_template.core.theme.custom.ButtonTypography
import ru.mobileup.kmm_template.core.theme.custom.CaptionTypography
import ru.mobileup.kmm_template.core.theme.custom.CustomTypography
import ru.mobileup.kmm_template.core.theme.custom.TitleTypography

val AppTypography = CustomTypography(
    title = TitleTypography(
        regular = TextStyle(
            fontSize = 24.sp
        )
    ),
    body = BodyTypography(
        regular = TextStyle(
            fontSize = 16.sp
        )
    ),
    caption = CaptionTypography(
        regular = TextStyle(
            fontSize = 12.sp
        )
    ),
    button = ButtonTypography(
        bold = TextStyle(
            fontSize = 16.sp,
            fontWeight = FontWeight.Bold
        )
    )
)