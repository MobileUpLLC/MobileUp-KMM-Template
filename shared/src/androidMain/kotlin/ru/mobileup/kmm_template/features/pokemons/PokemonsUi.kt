package ru.mobileup.kmm_template.features.pokemons

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.arkivanov.decompose.extensions.compose.stack.Children
import dev.icerock.moko.resources.compose.stringResource
import ru.mobileup.kmm_template.MR
import ru.mobileup.kmm_template.R
import ru.mobileup.kmm_template.core.dialog.BottomSheet
import ru.mobileup.kmm_template.core.theme.AppTheme
import ru.mobileup.kmm_template.core.theme.custom.CustomTheme
import ru.mobileup.kmm_template.features.pokemons.details.PokemonDetailsUi
import ru.mobileup.kmm_template.features.pokemons.list.PokemonListUi
import ru.mobileup.kmm_template.features.pokemons.presentation.FakePokemonsComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.PokemonsComponent
import ru.mobileup.kmm_template.features.pokemons.presentation.pokemon_votes.PokemonVotesComponent

@Composable
fun PokemonsUi(
    component: PokemonsComponent,
    modifier: Modifier = Modifier
) {
    val childStack by component.childStack.collectAsState()

    Box(modifier = modifier) {
        Children(childStack) { child ->
            when (val instance = child.instance) {
                is PokemonsComponent.Child.List -> PokemonListUi(instance.component)
                is PokemonsComponent.Child.Details -> PokemonDetailsUi(instance.component)
            }
        }

        Button(
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(24.dp)
                .size(48.dp)
                .clip(CircleShape),
            onClick = component::onPokemonVotesButtonClick
        ) {
            Icon(
                painter = painterResource(id = R.drawable.ic_24_tab1),
                contentDescription = null,
                tint = CustomTheme.colors.icon.invert
            )
        }
    }

    BottomSheet(dialogControl = component.bottomSheetControl) { pokemonVotesComponent ->
        PokemonVotesUi(
            component = pokemonVotesComponent,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp)
        )
    }
}

@Composable
fun PokemonVotesUi(
    component: PokemonVotesComponent,
    modifier: Modifier = Modifier
) {
    val votes by component.pokemonVotes.collectAsState()

    Column(modifier = modifier) {
        if (votes.votes.isEmpty()) {
            Text(
                modifier = Modifier.padding(24.dp),
                text = stringResource(resource = MR.strings.pokemons_votes_empty_description)
            )
        }
        votes.votes.forEach {
            val textColor = if (it.isPositive == true) {
                CustomTheme.colors.text.primary
            } else {
                CustomTheme.colors.text.invert
            }

            val voteTextResource = if (it.isPositive == true) {
                MR.strings.pokemons_votes_like
            } else {
                MR.strings.pokemons_votes_dislike
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    modifier = Modifier.padding(8.dp),
                    text = it.pokemonName
                )
                Text(
                    modifier = Modifier.padding(8.dp),
                    color = textColor,
                    text = stringResource(resource = voteTextResource)
                )
            }
        }
    }
}

@Preview
@Composable
private fun PokemonsUiPreview() {
    AppTheme {
        PokemonsUi(FakePokemonsComponent())
    }
}