package ru.mobileup.kmm_template.core.dialog

import com.arkivanov.decompose.ComponentContext

typealias StandardDialogControl = SimpleDialogControl<StandardDialogData>

fun ComponentContext.standardDialogControl(
    key: String
): StandardDialogControl {
    return simpleDialogControl(
        key = key,
        dismissableByUser = { data -> data.dismissableByUser }
    )
}

fun fakeStandardDialogControl(data: StandardDialogData = StandardDialogData.MOCK): StandardDialogControl {
    return fakeSimpleDialogControl(data)
}