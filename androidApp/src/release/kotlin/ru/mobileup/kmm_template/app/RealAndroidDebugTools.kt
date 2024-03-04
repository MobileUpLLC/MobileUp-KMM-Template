package ru.mobileup.kmm_template.app

import android.content.Context
import me.aartikov.replica.client.ReplicaClient
import okhttp3.Interceptor
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools

@Suppress("UNUSED_PARAMETER")
class RealAndroidDebugTools(context: Context) : AndroidDebugTools {

    override val interceptors: List<Interceptor> = emptyList()

    override fun launch(replicaClient: ReplicaClient) {
        // do nothing
    }
}