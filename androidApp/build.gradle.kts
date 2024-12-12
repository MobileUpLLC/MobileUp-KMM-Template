plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.detekt)
    alias(libs.plugins.compose.compiler)
}

android {
    val minSdkVersion = libs.versions.minSdk.get().toInt()
    val targetSdkVersion = libs.versions.targetSdk.get().toInt()
    val compileSdkVersion = libs.versions.compileSdk.get().toInt()

    namespace = "ru.mobileup.kmm_template.app"
    compileSdk = compileSdkVersion

    defaultConfig {
        applicationId = "ru.mobileup.kmm_template"
        minSdk = minSdkVersion
        targetSdk = targetSdkVersion
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        getByName("debug") {
        }

        create("release") {
        }
    }

    buildTypes {
        getByName("debug") {
            versionNameSuffix = "-debug"
            applicationIdSuffix = ".debug"
            signingConfig = signingConfigs["debug"]
        }

        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            setProguardFiles(
                listOf(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
                )
            )
            signingConfig = signingConfigs["release"]
        }
    }



    setFlavorDimensions(listOf("backend"))
    productFlavors {
        create("dev") {
            dimension = "backend"
        }

        create("prod") {
            dimension = "backend"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }

    buildFeatures {
        buildConfig = true
    }

    packaging {
        resources.excludes += "META-INF/INDEX.LIST"
        resources.excludes += "META-INF/io.netty.versions.properties"
    }
}

dependencies {
    implementation(project(":shared"))
    implementation(platform(libs.compose.bom))
    implementation(libs.bundles.compose)
    implementation(libs.splashscreen)
    implementation(libs.replica.core)
    implementation(libs.ktor.android)
    debugImplementation(libs.bundles.hyperion)
    debugImplementation(libs.chucker)
    debugImplementation(libs.replica.devtools)
}