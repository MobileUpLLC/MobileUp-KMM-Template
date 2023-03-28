package ru.mobileup.kmm_template.features.pokemons.ui.details

import com.arkivanov.decompose.ComponentContext
import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.StringDesc
import me.aartikov.replica.single.Replica
import ru.mobileup.kmm_template.core.error_handling.ErrorHandler
import ru.mobileup.kmm_template.core.utils.observe
import ru.mobileup.kmm_template.features.pokemons.domain.DetailedPokemon

class RealPokemonDetailsComponent(
    componentContext: ComponentContext,
    private val pokemonName: String,
    private val pokemonReplica: Replica<DetailedPokemon>,
    errorHandler: ErrorHandler
) : ComponentContext by componentContext, PokemonDetailsComponent {

    override val title: StringDesc get() = StringDesc.Raw(pokemonName)

    override val pokemonState = pokemonReplica.observe(this, errorHandler)

    override fun onRetryClick() {
        pokemonReplica.refresh()
    }

    override fun onRefresh() {
        pokemonReplica.refresh()
    }
}