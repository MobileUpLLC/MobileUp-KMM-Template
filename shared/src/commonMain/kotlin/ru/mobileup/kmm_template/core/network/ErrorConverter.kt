package ru.mobileup.kmm_template.core.network

import io.ktor.client.HttpClientConfig
import io.ktor.client.engine.HttpClientEngineConfig
import io.ktor.client.network.sockets.SocketTimeoutException
import io.ktor.client.plugins.ClientRequestException
import io.ktor.client.plugins.HttpResponseValidator
import io.ktor.client.statement.bodyAsText
import io.ktor.http.HttpStatusCode
import io.ktor.serialization.ContentConvertException
import io.ktor.utils.io.errors.IOException
import kotlinx.serialization.SerializationException
import ru.mobileup.kmm_template.core.error_handling.ApplicationException
import ru.mobileup.kmm_template.core.error_handling.DeserializationException
import ru.mobileup.kmm_template.core.error_handling.NoInternetException
import ru.mobileup.kmm_template.core.error_handling.NoServerResponseException
import ru.mobileup.kmm_template.core.error_handling.ServerException
import ru.mobileup.kmm_template.core.error_handling.UnauthorizedException
import ru.mobileup.kmm_template.core.error_handling.UnknownException
import kotlin.coroutines.cancellation.CancellationException

fun <T : HttpClientEngineConfig> HttpClientConfig<T>.setupErrorConverter() {
    expectSuccess = true

    HttpResponseValidator {
        handleResponseExceptionWithRequest { cause, _ ->
            if (cause is CancellationException) {
                throw cause
            }

            val exception = convertToApplicationException(cause)
            throw exception
        }
    }
}

private suspend fun convertToApplicationException(throwable: Throwable) = when (throwable) {
    is ApplicationException -> throwable
    is ClientRequestException -> when (throwable.response.status) {
        HttpStatusCode.GatewayTimeout, HttpStatusCode.ServiceUnavailable -> {
            NoServerResponseException(throwable)
        }
        HttpStatusCode.Unauthorized -> UnauthorizedException(throwable)
        else -> mapBadRequestException(throwable)
    }
    is ContentConvertException -> DeserializationException(throwable)
    is SocketTimeoutException -> NoServerResponseException(throwable)
    is IOException -> (throwable.cause as? ApplicationException) ?: NoInternetException(throwable)
    else -> UnknownException(throwable, throwable.message ?: "Unknown")
}

private suspend fun mapBadRequestException(exception: ClientRequestException): ApplicationException =
    try {
        val json = createDefaultJson()
        val errorBody = exception.response.bodyAsText()
        val errorMessage = null // TODO: parse errorBody

        ServerException(exception, errorMessage)
    } catch (e: Exception) {
        when (e) {
            is SerializationException, is IllegalArgumentException -> DeserializationException(e)
            else -> ServerException(e)
        }
    }