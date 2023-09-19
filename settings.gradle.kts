pluginManagement {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }
}

rootProject.name = "MobileUp KMM Template"
include(":androidApp")
include(":shared")

dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }

    versionCatalogs {
        create("libs") {
            // Kotlin
            val dateTimeVersion = "0.4.1"
            library("kotlinx-datetime", "org.jetbrains.kotlinx", "kotlinx-datetime").version(dateTimeVersion)

            // Concurrency
            val coroutinesVersion = "1.7.3"
            library("coroutines-core", "org.jetbrains.kotlinx", "kotlinx-coroutines-core").version(coroutinesVersion)
            library("coroutines-android", "org.jetbrains.kotlinx", "kotlinx-coroutines-android").version(coroutinesVersion)

            // Architecture
            val decomposeVersion = "2.0.2"
            val essentyVersion = "1.1.0"
            library("decompose-core", "com.arkivanov.decompose", "decompose").version(decomposeVersion)
            library("decompose-compose", "com.arkivanov.decompose", "extensions-compose-jetpack").version(decomposeVersion)
            library("essenty-lifecycle", "com.arkivanov.essenty", "lifecycle").version(
                essentyVersion
            )
            library("essenty-backhandler", "com.arkivanov.essenty", "back-handler").version(
                essentyVersion
            )

            // Network
            val ktorVersion = "2.3.4"
            val ktorfitVersion = "1.7.0"
            library("ktor-core", "io.ktor", "ktor-client-core").version(ktorVersion)
            library("ktor-auth", "io.ktor", "ktor-client-auth").version(ktorVersion)
            library("ktor-serialization", "io.ktor", "ktor-serialization-kotlinx-json").version(ktorVersion)
            library("ktor-content-negotiation", "io.ktor", "ktor-client-content-negotiation").version(ktorVersion)
            library("ktor-logging", "io.ktor", "ktor-client-logging").version(ktorVersion)
            library("ktor-android", "io.ktor", "ktor-client-okhttp").version(ktorVersion)
            library("ktor-ios", "io.ktor", "ktor-client-darwin").version(ktorVersion)
            library("ktorfit-lib", "de.jensklingenberg.ktorfit", "ktorfit-lib").version(ktorfitVersion)
            library("ktorfit-ksp", "de.jensklingenberg.ktorfit", "ktorfit-ksp").version(ktorfitVersion)
            bundle(
                "ktor-shared",
                listOf(
                    "ktor-core",
                    "ktor-serialization",
                    "ktor-content-negotiation",
                    "ktor-auth",
                    "ktor-logging"
                )
            )

            // Replica
            val replicaVersion = "1.0.0-alpha13"
            library("replica-core", "com.github.aartikov", "replica-core").version(replicaVersion)
            library("replica-algebra", "com.github.aartikov", "replica-algebra").version(replicaVersion)
            library("replica-decompose", "com.github.aartikov", "replica-decompose").version(replicaVersion)
            library("replica-androidNetwork", "com.github.aartikov", "replica-android-network").version(replicaVersion)
            library("replica-devtools", "com.github.aartikov", "replica-devtools").version(replicaVersion)
            bundle(
                "replica-shared",
                listOf(
                    "replica-core",
                    "replica-algebra",
                    "replica-decompose"
                )
            )

            // DI
            val koinVersion = "3.5.0"
            library("koin-core", "io.insert-koin", "koin-core").version(koinVersion)

            // Form validation
            val formValidationVersion = "1.0.0-alpha1"
            library("forms", "ru.mobileup", "kmm-form-validation").version(formValidationVersion)

            // Logging
            val kermitVersion = "1.2.2"
            library("logger-kermit", "co.touchlab", "kermit").version(kermitVersion)

            // Code quality
            val detectVersion = "1.23.1"
            library("detekt-formatting", "io.gitlab.arturbosch.detekt", "detekt-formatting").version(detectVersion)

            // Resources
            val mokoResourcesVersion = "0.23.0"
            library("moko-resources", "dev.icerock.moko", "resources").version(mokoResourcesVersion)
            library("moko-resourcesCompose", "dev.icerock.moko", "resources-compose").version(mokoResourcesVersion)

            // Android
            val androidDesugarVersion = "2.0.2"
            library("android-desugar", "com.android.tools", "desugar_jdk_libs").version(androidDesugarVersion)

            // Android UI
            val composeVersion = "1.5.1"
            version("composeCompiler", "1.5.3")
            val activityComposeVersion = "1.7.2"
            val activityVersion = "1.7.2"
            val coilVersion = "2.4.0"
            val splashscreenVersion = "1.0.0"
            val accompanistVersion = "0.32.0"
            library("compose-ui", "androidx.compose.ui", "ui").version(composeVersion)
            library("compose-material", "androidx.compose.material", "material").version(composeVersion)
            library("compose-tooling", "androidx.compose.ui", "ui-tooling").version(composeVersion)
            library("activity-compose", "androidx.activity", "activity-compose").version(activityComposeVersion)
            library("activity", "androidx.activity", "activity-ktx").version(activityVersion)
            bundle(
                "compose",
                listOf(
                    "compose-ui",
                    "compose-material",
                    "compose-tooling",
                    "activity-compose"
                )
            )

            library("coil", "io.coil-kt", "coil-compose").version(coilVersion)
            library("splashscreen", "androidx.core", "core-splashscreen").version(splashscreenVersion)

            library("accompanist-systemuicontroller", "com.google.accompanist", "accompanist-systemuicontroller").version(accompanistVersion)
            bundle("accompanist",
                listOf(
                    "accompanist-systemuicontroller"
                )
            )

            // Debug tools
            val chuckerVersion = "4.0.0"
            val hyperionVersion = "0.9.37"
            val hyperionAddonsVersion = "0.3.3"
            library("chucker", "com.github.chuckerteam.chucker", "library").version(chuckerVersion)
            library("hyperion-core", "com.willowtreeapps.hyperion", "hyperion-core").version(hyperionVersion)
            library("hyperion-recorder", "com.willowtreeapps.hyperion", "hyperion-recorder").version(hyperionVersion)
            library("hyperion-crash", "com.willowtreeapps.hyperion", "hyperion-crash").version(hyperionVersion)
            library("hyperion-disk", "com.willowtreeapps.hyperion", "hyperion-disk").version(hyperionVersion)
            library("hyperion-addons-networkEmulation", "me.nemiron.hyperion", "network-emulation").version(hyperionAddonsVersion)
            library("hyperion-addons-chucker", "me.nemiron.hyperion", "chucker").version(hyperionAddonsVersion)
            bundle(
                "hyperion",
                listOf(
                    "hyperion-core",
                    "hyperion-recorder",
                    "hyperion-crash",
                    "hyperion-disk",
                    "hyperion-addons-networkEmulation",
                    "hyperion-addons-chucker"
                )
            )
        }
    }
}