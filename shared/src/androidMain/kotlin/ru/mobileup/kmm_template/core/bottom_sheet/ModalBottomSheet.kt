package ru.mobileup.kmm_template.core.bottom_sheet

import android.annotation.SuppressLint
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

@Composable
@OptIn(ExperimentalMaterialApi::class)
fun <T : Any> ModalBottomSheet(
    modifier: Modifier = Modifier,
    control: BottomSheetControl<*, T>,
    bottomSheetContent: @Composable (T) -> Unit
) {
    val systemBarsPadding = WindowInsets.systemBars.asPaddingValues()
    val navigationBarHeight = systemBarsPadding.calculateBottomPadding()

    val bottomSheetOverlay by control.sheetOverlay.collectAsState()
    val componentBottomSheetState by control.sheetState.collectAsState()

    val modalBottomSheetState =
        rememberModalBottomSheetState(
            initialValue = componentBottomSheetState.toCompose(),
            skipHalfExpanded = !control.halfExpandingSupported,
            confirmValueChange = { control.onStateChanged(it.toSheetControlState()) }
        )

    modalBottomSheetState.handleBottomSheetState(componentBottomSheetState)
    ModalBottomSheetLayout(
        modifier = modifier,
        sheetContent = {
            (bottomSheetOverlay.overlay?.instance)?.let {
                Box(modifier = Modifier.padding(bottom = navigationBarHeight)) {
                    bottomSheetContent(it)
                }
            }
        },
        sheetState = modalBottomSheetState,
        sheetShape = RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp),
    ) {}
}

@SuppressLint("ComposableNaming")
@OptIn(ExperimentalMaterialApi::class)
@Composable
private fun ModalBottomSheetState.handleBottomSheetState(
    componentBottomSheetState: BottomSheetControl.State,
) {
    LaunchedEffect(componentBottomSheetState) {
        when (componentBottomSheetState) {
            BottomSheetControl.State.Expanded -> {
                if (componentBottomSheetState.toCompose() != ModalBottomSheetValue.Expanded) {
                    launch { show() }
                }
            }
            BottomSheetControl.State.Hidden -> {
                launch { hide() }
            }
            BottomSheetControl.State.HalfExpanded -> {
                if (componentBottomSheetState.toCompose() != ModalBottomSheetValue.HalfExpanded) {
                    launch { show() }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterialApi::class)
private fun BottomSheetControl.State.toCompose(): ModalBottomSheetValue =
    when (this) {
        BottomSheetControl.State.Expanded -> ModalBottomSheetValue.Expanded
        BottomSheetControl.State.Hidden -> ModalBottomSheetValue.Hidden
        BottomSheetControl.State.HalfExpanded -> ModalBottomSheetValue.HalfExpanded
    }

@OptIn(ExperimentalMaterialApi::class)
private fun ModalBottomSheetValue.toSheetControlState(): BottomSheetControl.State =
    when (this) {
        ModalBottomSheetValue.Expanded -> BottomSheetControl.State.Expanded
        ModalBottomSheetValue.Hidden -> BottomSheetControl.State.Hidden
        ModalBottomSheetValue.HalfExpanded -> BottomSheetControl.State.HalfExpanded
    }