package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.ComponentContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.serialization.KSerializer

typealias SimpleDialogControl<T> = DialogControl<T, T>

fun <T : Any> ComponentContext.simpleDialogControl(
    key: String,
    dismissableByUser: (T) -> Boolean = { true },
    serializer: KSerializer<T>? = null
): SimpleDialogControl<T> {
    return dialogControl(
        key = key,
        dialogComponentFactory = { data, _, _ -> data },
        dismissableByUser = { data, _ -> MutableStateFlow(dismissableByUser(data)) },
        serializer = serializer
    )
}

fun <T : Any> fakeSimpleDialogControl(data: T): SimpleDialogControl<T> {
    return fakeDialogControl(data, data)
}