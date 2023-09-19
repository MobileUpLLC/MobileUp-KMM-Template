package ru.mobileup.kmm_template.core.bottom_sheet

import android.annotation.SuppressLint
import androidx.compose.animation.core.TweenSpec
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.ModalBottomSheetDefaults
import androidx.compose.material.ModalBottomSheetLayout
import androidx.compose.material.ModalBottomSheetState
import androidx.compose.material.ModalBottomSheetValue
import androidx.compose.material.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.isSpecified
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.semantics.onClick
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import ru.mobileup.kmm_template.core.utils.LocalEdgeToEdgeSettings
import ru.mobileup.kmm_template.core.utils.accumulate

@Composable
@OptIn(ExperimentalMaterialApi::class)
fun <T : Any> ModalBottomSheet(
    modifier: Modifier = Modifier,
    addNavigationBarPadding: Boolean = true,
    control: BottomSheetControl<*, T>,
    bottomSheetContent: @Composable (T) -> Unit
) {
    val systemBarsPadding = WindowInsets.systemBars.asPaddingValues()
    val statusBarHeight = systemBarsPadding.calculateTopPadding()
    val navigationBarHeight = systemBarsPadding.calculateBottomPadding()
    val edgeToEdgeSettings = LocalEdgeToEdgeSettings.current.accumulate()
    val needNavigationBarPadding = edgeToEdgeSettings.transparentNavigationBar

    val bottomSheetSlot by control.sheetSlot.collectAsState()
    val componentBottomSheetState by control.sheetState.collectAsState()

    val initialValue = remember { componentBottomSheetState.toCompose() }
    val skipHalfExpended = remember { !control.halfExpandingSupported }

    /**
     * Optional callback invoked to confirm or veto a pending state change.
     */
    val change = remember<(ModalBottomSheetValue) -> Boolean>(control) {
        {
            control.shouldUpdateState(it.toSheetControlState())
        }
    }

    val modalBottomSheetState = rememberModalBottomSheetState(
        initialValue = initialValue,
        skipHalfExpanded = skipHalfExpended,
        confirmValueChange = { change(it) }
    )

    modalBottomSheetState.handleBottomSheetState(
        onStateChanged = control::onStateChangedFromUI,
        onStateChangeAnimationEnd = control::onStateChangeAnimationEnd,
        componentBottomSheetState = componentBottomSheetState
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .offset(y = -statusBarHeight)
    ) {
        ScrimUi(
            color = ModalBottomSheetDefaults.scrimColor,
            visible = modalBottomSheetState.targetValue != ModalBottomSheetValue.Hidden,
            isClickable = false
        )
    }

    ModalBottomSheetLayout(
        scrimColor = Color.Transparent,
        modifier = modifier,
        sheetContent = {
            (bottomSheetSlot.child?.instance)?.let {
                val contentModifier = if (addNavigationBarPadding && needNavigationBarPadding) {
                    Modifier.padding(bottom = navigationBarHeight)
                } else {
                    Modifier
                }

                Box(modifier = contentModifier) {
                    bottomSheetContent(it)
                }
            }
        },
        sheetState = modalBottomSheetState,
        sheetShape = RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp),
    ) {}
}

@Composable
private fun ScrimUi(
    color: Color,
    onDismiss: () -> Unit = {},
    visible: Boolean,
    isClickable: Boolean
) {
    if (color.isSpecified) {
        val alpha by animateFloatAsState(
            targetValue = if (visible) 1f else 0f,
            animationSpec = TweenSpec()
        )
        val dismissModifier = if (visible && isClickable) {
            Modifier
                .pointerInput(onDismiss) { detectTapGestures { onDismiss() } }
                .semantics(mergeDescendants = true) {
                    onClick { onDismiss(); true }
                }
        } else {
            Modifier
        }

        Canvas(
            Modifier
                .fillMaxSize()
                .then(dismissModifier)
        ) {
            drawRect(color = color, alpha = alpha)
        }
    }
}

/**
 * Для обработки событий изменения состояний ботомшита. Когда мы вызываем метод 'show'
 * в компоненте. Например 'bottomSheetControl.show(PokemonVotesComponent.Config)'
 */
@SuppressLint("ComposableNaming")
@OptIn(ExperimentalMaterialApi::class)
@Composable
private fun ModalBottomSheetState.handleBottomSheetState(
    onStateChanged: (BottomSheetControl.State) -> Unit,
    onStateChangeAnimationEnd: (BottomSheetControl.State) -> Unit,
    componentBottomSheetState: BottomSheetControl.State,
) {
    LaunchedEffect(componentBottomSheetState) {
        when (componentBottomSheetState) {
            BottomSheetControl.State.Expanded -> {
                if (componentBottomSheetState.toCompose() != ModalBottomSheetValue.Expanded
                    || currentValue != componentBottomSheetState.toCompose()
                ) {
                    launch {
                        show()
                        onStateChangeAnimationEnd(componentBottomSheetState)
                    }
                }
            }

            BottomSheetControl.State.Hidden -> {
                launch {
                    hide()
                    onStateChangeAnimationEnd(componentBottomSheetState)
                }
            }

            BottomSheetControl.State.HalfExpanded -> {
                if (componentBottomSheetState.toCompose() != ModalBottomSheetValue.HalfExpanded
                    || currentValue != componentBottomSheetState.toCompose()
                ) {
                    launch {
                        show()
                        onStateChangeAnimationEnd(componentBottomSheetState)
                    }
                }
            }
        }
    }

    /**
     * Нужен что бы менять состояние боттомшита через ui.
     * Например когда свайпаешь ботомшит вниз что бы закрыть,
     * после закрытия ботом шита вызывается сайд эффект ModalBottomSheetValue.Hidden
     */
    LaunchedEffect(currentValue) {
        when (currentValue) {
            ModalBottomSheetValue.Hidden -> {
                if (componentBottomSheetState.toCompose() != currentValue) {
                    onStateChanged(BottomSheetControl.State.Hidden)
                }
            }

            ModalBottomSheetValue.HalfExpanded -> {
                if (componentBottomSheetState.toCompose() != currentValue) {
                    onStateChanged(BottomSheetControl.State.HalfExpanded)
                }
            }

            else -> {}
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