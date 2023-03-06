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
        is ServerException -> message?.let { StringDesc.Raw(it) }
            ?: StringDesc.Resource(MR.strings.error_invalid_response)
        is DeserializationException -> StringDesc.Resource(MR.strings.error_invalid_response)
        is NoServerResponseException -> StringDesc.Resource(MR.strings.error_no_server_response)
        is NoInternetException -> StringDesc.Resource(MR.strings.error_no_internet_connection)
        is ExternalAppNotFoundException -> StringDesc.Resource(MR.strings.error_matching_application_not_found)
        else -> StringDesc.Resource(MR.strings.error_unexpected)
    }