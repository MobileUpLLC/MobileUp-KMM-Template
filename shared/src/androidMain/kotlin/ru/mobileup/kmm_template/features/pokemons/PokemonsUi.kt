package ru.mobileup.kmm_template.features.pokemons

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.arkivanov.decompose.extensions.compose.jetpack.stack.Children
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.features.pokemons.details.PokemonDetailsUi
import ru.mobileup.kmm_template.features.pokemons.list.PokemonListUi
import ru.mobileup.kmm_template.features.pokemons.ui.FakePokemonsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.PokemonsComponent

@Composable
fun PokemonsUi(
    component: PokemonsComponent,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    Children(childStack, modifier) { child ->
        when (val instance = child.instance) {
            is PokemonsComponent.Child.List -> PokemonListUi(instance.component)
            is PokemonsComponent.Child.Details -> PokemonDetailsUi(instance.component)
        }
    }
}

@Preview
@Composable
fun PokemonsUiPreview() {
    AppTheme {
        PokemonsUi(FakePokemonsComponent())
    }
}