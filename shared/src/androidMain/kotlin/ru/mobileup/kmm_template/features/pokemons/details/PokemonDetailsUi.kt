package ru.mobileup.kmm_template.features.pokemons.details

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
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
import androidx.compose.ui.window.DialogProperties
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.arkivanov.decompose.router.slot.ChildSlot
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.utils.dispatchOnBackPressed
import ru.mobileup.kmm_template.core.widget.RefreshingProgress
import ru.mobileup.kmm_template.core.widget.SwipeRefreshLceWidget
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon
import ru.mobileup.kmm_template.features.pokemons.list.PokemonTypeItem
import ru.mobileup.kmm_template.features.pokemons.ui.details.FakePokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.PokemonDetailsComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.PokemonVoteDialogComponent
import ru.mobileup.kmm_template.features.pokemons.ui.details.vote.model.PokemonVoteState

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun PokemonDetailsUi(
    component: PokemonDetailsComponent,
    modifier: Modifier = Modifier
) {
    val pokemonState by component.pokemonState.collectAsState()
    val dialogSlot by component.dialogControl.dialogOverlay.collectAsState()
    val pokemonVoteState by component.pokemonVoteState.collectAsState()

    val context = LocalContext.current
    val voteButtonColor = when (pokemonVoteState) {
        PokemonVoteState.POSITIVE -> MaterialTheme.colors.secondary
        PokemonVoteState.NEGATIVE -> MaterialTheme.colors.error
        PokemonVoteState.NONE -> MaterialTheme.colors.primary
    }

    Column(modifier = modifier.fillMaxSize()) {
        IconButton(
            onClick = { dispatchOnBackPressed(context) }
        ) {
            Icon(imageVector = Icons.Filled.ArrowBack, contentDescription = null)
        }

        SwipeRefreshLceWidget(
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

    PokemonDetailsDialog(dialogSlot, component)
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
            style = MaterialTheme.typography.h5
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
                .background(color = MaterialTheme.colors.surface)
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
            colors = ButtonDefaults.buttonColors(backgroundColor = voteButtonColor),
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
    dialogSlot: ChildSlot<*, PokemonVoteDialogComponent>,
    component: PokemonDetailsComponent
) {
    when (val dialogComponent = dialogSlot.child?.instance) {
        is PokemonVoteDialogComponent -> {
            val dialogData = dialogComponent.dialogData.collectAsState()

            /**
             * 'dismiss' можно вызвать непосредственно у dialogControl
             * или же пробросить вызов через реализацию компонента диалога
             * 'dialogComponent::dismiss' где реализовать специфическую логику
             */
            AlertDialog(
                onDismissRequest = component.dialogControl::dismiss,
                buttons = {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 8.dp, vertical = 4.dp),
                        horizontalArrangement = Arrangement.SpaceEvenly
                    ) {
                        Button(onClick = dialogComponent::votePositive) {
                            Text(text = stringResource(MR.strings.pokemons_dialog_vote_positive))
                        }

                        Button(onClick = dialogComponent::voteNegative) {
                            Text(text = stringResource(MR.strings.pokemons_dialog_vote_negative))
                        }
                    }
                },
                title = {
                    Text(
                        modifier = Modifier.padding(8.dp),
                        text = stringResource(
                            MR.strings.pokemons_dialog_title,
                            dialogData.value.pokemonName
                        )
                    )
                },
                text = {
                    Text(
                        modifier = Modifier.padding(8.dp),
                        text = stringResource(
                            MR.strings.pokemons_dialog_description,
                            dialogData.value.pokemonName,
                            dialogData.value.formatPokemonTypes
                        )
                    )
                },
                properties = DialogProperties(
                    dismissOnBackPress = component.dialogControl.canDismissed,
                    dismissOnClickOutside = component.dialogControl.canDismissed
                )
            )
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