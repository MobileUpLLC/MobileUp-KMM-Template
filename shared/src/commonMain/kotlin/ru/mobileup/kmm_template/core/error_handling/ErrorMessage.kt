package ru.mobileup.kmm_template.core.error_handling

import dev.icerock.moko.resources.desc.Raw
import dev.icerock.moko.resources.desc.Resource
import dev.icerock.moko.resources.desc.StringDesc
import ru.mobileup.kmm_template.MR

/**
 * Returns human readable messages for exceptions.
 */
val Exception.errorMessage: StringDesc
    get() = when (this) {

        is ExternalAppNotFoundException -> StringDesc.Resource(MR.strings.error_matching_application_not_found)

        is ServerUnavailableException -> StringDesc.Resource(MR.strings.error_server_unavailable)

        is NoInternetException -> StringDesc.Resource(MR.strings.error_no_internet_connection)

        is UnauthorizedException -> StringDesc.Resource(MR.strings.error_unauthorized)

        is SSLHandshakeException -> StringDesc.Resource(MR.strings.error_ssl_handshake)

        is ServerException -> message?.let { StringDesc.Raw(it) }
            ?: StringDesc.Resource(MR.strings.error_server)

        is DeserializationException -> StringDesc.Resource(MR.strings.error_deserialization)

        else -> StringDesc.Resource(MR.strings.error_unexpected)
    }