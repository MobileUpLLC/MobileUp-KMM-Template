package ru.mobileup.kmm_template.core.theme

import androidx.compose.ui.graphics.Color
import ru.mobileup.kmm_template.core.theme.custom.BackgroundColors
import ru.mobileup.kmm_template.core.theme.custom.ButtonColors
import ru.mobileup.kmm_template.core.theme.custom.CustomColors
import ru.mobileup.kmm_template.core.theme.custom.IconColors
import ru.mobileup.kmm_template.core.theme.custom.TextColors

val LightAppColors = CustomColors(
    isLight = true,
    background = BackgroundColors(
        screen = Color(0xFFFFFFFF),
        toast = Color(0xFF000000)
    ),
    text = TextColors(
        primary = Color(0xFF000000),
        secondary = Color(0xFF797979),
        invert = Color(0xFFFFFFFF),
    ),
    icon = IconColors(
        primary = Color(0xFF000000),
        secondary = Color(0xFF797979),
        invert = Color(0xFFFFFFFF),
    ),
    button = ButtonColors(
        primary = Color(0xFF6750A4),
        secondary = Color(0xFFFFFFFF),
    )
)

val DarkAppColors = LightAppColors