package ru.mobileup.kmm_template.features.home

import androidx.annotation.DrawableRes
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemColors
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import com.arkivanov.decompose.extensions.compose.stack.Children
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.features.home.tab1.Tab1Ui
import ru.mobileup.kmm_template.features.home.tab2.Tab2Ui
import ru.mobileup.kmm_template.features.pokemons.PokemonsUi

@Composable
fun HomeUi(
    component: HomeComponent,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    Scaffold(
        modifier = modifier,
        contentWindowInsets = WindowInsets.systemBars,
        content = { innerPadding ->
            Children(
                childStack,
                modifier = Modifier.padding(innerPadding)
            ) { child ->
                when (val instance = child.instance) {
                    is HomeComponent.Child.Tab1 -> Tab1Ui(instance.component)
                    is HomeComponent.Child.Tab2 -> Tab2Ui(instance.component)
                    is HomeComponent.Child.Tab3 -> PokemonsUi(instance.component)
                }
            }
        },
        bottomBar = {
            BottomBar(
                currentChild = childStack.active.instance,
                onTabSelect = component::onTabSelected
            )
        }
    )
}

@Composable
fun BottomBar(currentChild: HomeComponent.Child, onTabSelect: (HomeTab) -> Unit) {
    NavigationBar {
        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab1,
            label = stringResource(MR.strings.home_tab1_label),
            isSelected = currentChild is HomeComponent.Child.Tab1,
            onClick = { onTabSelect(HomeTab.Tab1) }
        )

        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab2,
            label = stringResource(MR.strings.home_tab2_label),
            isSelected = currentChild is HomeComponent.Child.Tab2,
            onClick = { onTabSelect(HomeTab.Tab2) }
        )

        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab3,
            label = stringResource(MR.strings.home_tab3_label),
            isSelected = currentChild is HomeComponent.Child.Tab3,
            onClick = { onTabSelect(HomeTab.Tab3) }
        )
    }
}

@Composable
fun RowScope.NavigationItem(
    @DrawableRes iconRes: Int,
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    NavigationBarItem(
        modifier = modifier,
        icon = {
            Icon(painterResource(iconRes), contentDescription = null)
        },
        label = {
            Text(label, maxLines = 1, overflow = TextOverflow.Ellipsis)
        },
        selected = isSelected,
        onClick = onClick,
        colors = NavigationBarItemColors(
            selectedIconColor = CustomTheme.colors.icon.primary,
            unselectedIconColor = CustomTheme.colors.icon.secondary,
            selectedTextColor = CustomTheme.colors.text.primary,
            unselectedTextColor = CustomTheme.colors.text.secondary,
            selectedIndicatorColor = Color.Transparent,
            disabledIconColor = CustomTheme.colors.icon.invert,
            disabledTextColor = CustomTheme.colors.text.invert
        )
    )
}

@Preview(showSystemUi = true)
@Composable
private fun HomeUiPreview() {
    AppTheme {
        HomeUi(FakeHomeComponent())
    }
}