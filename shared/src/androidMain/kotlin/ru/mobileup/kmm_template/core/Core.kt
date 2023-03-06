package ru.mobileup.kmm_template.core

import android.app.Application
import me.aartikov.replica.client.ReplicaClient
import ru.mobileup.kmm_template.core.activity.ActivityProvider
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools

val Application.core get() = (this as CoreProvider).core

val Core.activityProvider get() = get<ActivityProvider>()

fun Core.launchAndroidDebugTools() {
    val replicaClient = get<ReplicaClient>()
    val androidDebugTools = get<AndroidDebugTools>()
    androidDebugTools.launch(replicaClient)
}