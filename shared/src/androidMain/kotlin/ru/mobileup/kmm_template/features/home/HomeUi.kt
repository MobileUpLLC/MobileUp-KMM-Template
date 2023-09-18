package ru.mobileup.kmm_template.features.home

import androidx.annotation.DrawableRes
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.padding
import androidx.compose.material.BottomNavigation
import androidx.compose.material.BottomNavigationItem
import androidx.compose.material.Icon
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import com.arkivanov.decompose.extensions.compose.jetpack.stack.Children
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
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
        content = { contentPadding ->
            Children(
                childStack,
                modifier = Modifier.padding(contentPadding)
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
                onTabSelected = component::onTabSelected)
        }
    )
}

@Composable
fun BottomBar(currentChild: HomeComponent.Child, onTabSelected: (HomeTab) -> Unit) {
    BottomNavigation(
        backgroundColor = MaterialTheme.colors.surface
    ) {
        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab1,
            label = stringResource(MR.strings.home_tab1_label),
            isSelected = currentChild is HomeComponent.Child.Tab1,
            onClick = { onTabSelected(HomeTab.Tab1) }
        )

        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab2,
            label = stringResource(MR.strings.home_tab2_label),
            isSelected = currentChild is HomeComponent.Child.Tab2,
            onClick = { onTabSelected(HomeTab.Tab2) }
        )

        NavigationItem(
            iconRes = ru.mobileup.kmm_template.R.drawable.ic_24_tab3,
            label = stringResource(MR.strings.home_tab3_label),
            isSelected = currentChild is HomeComponent.Child.Tab3,
            onClick = { onTabSelected(HomeTab.Tab3) }
        )
    }
}

@Composable
fun RowScope.NavigationItem(
    @DrawableRes iconRes: Int,
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    BottomNavigationItem(
        icon = {
            Icon(painterResource(iconRes), contentDescription = null)
        },
        label = {
            Text(label, maxLines = 1, overflow = TextOverflow.Ellipsis)
        },
        selected = isSelected,
        onClick = onClick,
        selectedContentColor = MaterialTheme.colors.primary,
        unselectedContentColor = MaterialTheme.colors.onSurface
    )
}

@Preview(showSystemUi = true)
@Composable
fun HomeUiPreview() {
    AppTheme {
        HomeUi(FakeHomeComponent())
    }
}