package ru.mobileup.kmm_template.features.pokemons.details

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.dialog.Dialog
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.core.utils.dispatchOnBackPressed
import ru.mobileup.kmm_template.core.widget.PullRefreshLceWidget
import ru.mobileup.kmm_template.core.widget.RefreshingProgress
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.list.PokemonTypeItem
import ru.mobileup.kmm_template.features.pokemons.ui.details.FakePokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteState

@Composable
fun PokemonDetailsUi(
    component: PokemonDetailsComponent,
    modifier: Modifier = Modifier
) {
    val pokemonState by component.pokemonState.collectAsState()
    val pokemonVoteState by component.pokemonVoteState.collectAsState()

    val context = LocalContext.current
    val voteButtonColor = when (pokemonVoteState) {
        PokemonVoteState.POSITIVE -> CustomTheme.colors.button.primary
        PokemonVoteState.NEGATIVE -> CustomTheme.colors.button.secondary
        PokemonVoteState.NONE -> CustomTheme.colors.button.secondary
    }

    Column(modifier = modifier.fillMaxSize()) {
        IconButton(
            onClick = { dispatchOnBackPressed(context) }
        ) {
            Icon(imageVector = Icons.Filled.ArrowBack, contentDescription = null)
        }

        PullRefreshLceWidget(
            state = pokemonState,
            onRefresh = component::onRefresh,
            onRetryClick = component::onRetryClick
        ) { pokemon, refreshing ->
            PokemonDetailsContent(
                pokemon = pokemon,
                voteButtonColor = voteButtonColor,
                onPokemonVoteClick = component::onVoteClick
            )
            RefreshingProgress(refreshing, modifier = Modifier.padding(top = 4.dp))
        }
    }

    Dialog(dialogControl = component.dialogControl) {
        PokemonDetailsDialog(it)
    }
}

@Composable
private fun PokemonDetailsContent(
    pokemon: DetailedPokemon,
    voteButtonColor: Color,
    modifier: Modifier = Modifier,
    onPokemonVoteClick: () -> Unit = {}
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            textAlign = TextAlign.Center,
            text = pokemon.name,
            style = CustomTheme.typography.title.regular
        )

        AsyncImage(
            contentDescription = null,
            model = ImageRequest.Builder(LocalContext.current)
                .data(pokemon.imageUrl)
                .crossfade(true)
                .build(),
            contentScale = ContentScale.Crop,
            modifier = Modifier
                .padding(top = 32.dp)
                .size(200.dp)
                .clip(CircleShape)
                .background(color = CustomTheme.colors.background.screen)
        )

        Text(
            modifier = Modifier.padding(top = 32.dp),
            text = stringResource(MR.strings.pokemons_types)
        )

        Row(
            modifier = Modifier.padding(top = 12.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            pokemon.types.forEach {
                PokemonTypeItem(type = it, isSelected = true)
            }
        }

        Row(
            modifier = Modifier.padding(top = 32.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(
                text = stringResource(MR.strings.pokemons_height, pokemon.height)
            )
            Text(
                text = stringResource(MR.strings.pokemons_weight, pokemon.weight)
            )
        }

        Button(
            modifier = Modifier.padding(16.dp),
            colors = ButtonDefaults.buttonColors(containerColor = voteButtonColor),
            onClick = onPokemonVoteClick
        ) {
            Text(
                modifier = Modifier.padding(4.dp),
                text = stringResource(MR.strings.pokemons_vote)
            )
        }
    }
}

@Composable
private fun PokemonDetailsDialog(
    component: PokemonVoteDialogComponent
) {
    val dialogData = component.dialogData.collectAsState()

    /**
     * 'dismiss' можно вызвать непосредственно у dialogControl
     * или же пробросить вызов через реализацию компонента диалога
     * 'dialogComponent::dismiss' где реализовать специфическую логику
     */
    Column(modifier = Modifier.background(CustomTheme.colors.background.screen)) {
        Text(
            modifier = Modifier.padding(8.dp),
            text = stringResource(
                MR.strings.pokemons_dialog_title,
                dialogData.value.pokemonName
            )
        )
        Text(
            modifier = Modifier.padding(8.dp),
            text = stringResource(
                MR.strings.pokemons_dialog_description,
                dialogData.value.pokemonName,
                dialogData.value.formatPokemonTypes
            )
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 8.dp, vertical = 4.dp),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Button(onClick = component::votePositive) {
                Text(text = stringResource(MR.strings.pokemons_dialog_vote_positive))
            }

            Button(onClick = component::voteNegative) {
                Text(text = stringResource(MR.strings.pokemons_dialog_vote_negative))
            }
        }
    }
}

@Preview(showSystemUi = true)
@Composable
fun PokemonDetailsUiPreview() {
    AppTheme {
        PokemonDetailsUi(FakePokemonDetailsComponent())
    }
}