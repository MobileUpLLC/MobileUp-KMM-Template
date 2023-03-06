package ru.mobileup.kmm_template.app

import android.content.Context
import com.chuckerteam.chucker.api.ChuckerCollector
import com.chuckerteam.chucker.api.ChuckerInterceptor
import com.chuckerteam.chucker.api.RetentionManager
import me.aartikov.replica.client.ReplicaClient
import me.aartikov.replica.devtools.ReplicaDevTools
import me.nemiron.hyperion.networkemulation.NetworkEmulatorInterceptor
import okhttp3.Interceptor
import ru.mobileup.kmm_template.core.debug_tools.AndroidDebugTools
import ru.mobileup.kmm_template.core.error_handling.ServerException
import java.io.IOException

class RealAndroidDebugTools(private val context: Context) : AndroidDebugTools {

    private val networkEmulatorInterceptor = NetworkEmulatorInterceptor(
        context,
        failureExceptionProvider = { IOException(ServerException(cause = null)) }
    )

    private val chuckerCollector = ChuckerCollector(
        context = context,
        showNotification = false,
        retentionPeriod = RetentionManager.Period.ONE_HOUR
    )

    private val chuckerInterceptor = ChuckerInterceptor
        .Builder(context)
        .collector(chuckerCollector)
        .build()

    override val interceptors: List<Interceptor> = listOf(
        networkEmulatorInterceptor,
        chuckerInterceptor
    )

    override fun launch(replicaClient: ReplicaClient) {
        ReplicaDevTools(replicaClient, context).launch()
    }

    @Suppress("DEPRECATION")
    override fun collectNetworkError(exception: Exception) {
        chuckerCollector.onError("DebugTools", exception)
    }
}