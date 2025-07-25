package ru.mobileup.kmm_template.features.pokemons.list

import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.core.widget.EmptyPlaceholder
import ru.mobileup.kmm_template.core.widget.PullRefreshLceWidget
import ru.mobileup.kmm_template.core.widget.RefreshingProgress
import ru.mobileup.kmm_template.features.pokemons.domain.Pokemon
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonId
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonType
import ru.mobileup.kmm_template.features.pokemons.domain.PokemonTypeId
import ru.mobileup.kmm_template.features.pokemons.presentation.list.FakePokemonListComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.list.PokemonListComponent

@Composable
fun PokemonListUi(
    component: PokemonListComponent,
    modifier: Modifier = Modifier
) {
    val types by component.types.collectAsState()
    val selectedTypeId by component.selectedTypeId.collectAsState()
    val pokemonsState by component.pokemonsState.collectAsState()

    Column(modifier = modifier.fillMaxSize()) {
        PokemonTypesRow(
            types = types,
            selectedTypeId = selectedTypeId,
            onTypeClick = component::onTypeClick
        )

        PullRefreshLceWidget(
            state = pokemonsState,
            onRefresh = component::onRefresh,
            onRetryClick = component::onRetryClick
        ) { pokemons, refreshing, paddingValues ->
            Box(modifier = Modifier.padding(paddingValues)) {
                if (pokemons.isNotEmpty()) {
                    PokemonListContent(
                        pokemons = pokemons,
                        onPokemonClick = component::onPokemonClick
                    )
                } else {
                    EmptyPlaceholder(
                        description = stringResource(MR.strings.pokemons_empty_description)
                    )
                }
                RefreshingProgress(refreshing)
            }
        }
    }
}

@Composable
private fun PokemonTypesRow(
    types: List<PokemonType>,
    selectedTypeId: PokemonTypeId,
    onTypeClick: (PokemonTypeId) -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        color = CustomTheme.colors.background.screen,
        shadowElevation = 4.dp
    ) {
        Column {
            Text(
                modifier = Modifier.padding(start = 16.dp, end = 16.dp, top = 12.dp),
                text = stringResource(MR.strings.pokemons_select_type),
                style = CustomTheme.typography.title.regular
            )
            Row(
                modifier = Modifier
                    .horizontalScroll(rememberScrollState())
                    .padding(horizontal = 16.dp, vertical = 12.dp)
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                types.forEach {
                    PokemonTypeItem(
                        type = it,
                        isSelected = it.id == selectedTypeId,
                        onClick = { onTypeClick(it.id) }
                    )
                }
            }
        }
    }
}

@Composable
private fun PokemonListContent(
    pokemons: List<Pokemon>,
    onPokemonClick: (PokemonId) -> Unit,
    modifier: Modifier = Modifier
) {
    LazyColumn(
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(vertical = 12.dp)
    ) {
        items(
            items = pokemons,
            key = { it.id.value }
        ) { pokemon ->
            PokemonItem(
                pokemon = pokemon,
                onClick = { onPokemonClick(pokemon.id) }
            )

            if (pokemon !== pokemons.lastOrNull()) {
                HorizontalDivider()
            }
        }
    }
}

@Composable
private fun PokemonItem(
    pokemon: Pokemon,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Text(
        modifier = modifier
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 12.dp)
            .fillMaxWidth(),
        text = pokemon.name
    )
}

@Preview(showSystemUi = true)
@Composable
private fun PokemonListUiPreview() {
    AppTheme {
        PokemonListUi(FakePokemonListComponent())
    }
}