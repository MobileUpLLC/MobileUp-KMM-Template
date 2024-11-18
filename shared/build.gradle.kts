import io.gitlab.arturbosch.detekt.Detekt

plugins {
    alias(libs.plugins.kotlin.multiplatform)
    alias(libs.plugins.kotlin.plugin.serialization)
    alias(libs.plugins.android.library)
    alias(libs.plugins.ksp)
    alias(libs.plugins.ktorfit)
    alias(libs.plugins.kotlin.plugin.parcelize)
    alias(libs.plugins.mokoResources)
    alias(libs.plugins.moduleGraph)
    alias(libs.plugins.detekt)
    alias(libs.plugins.kotlin.plugin.compose)
}

kotlin {
    applyDefaultHierarchyTemplate()
    androidTarget()

    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = "shared"
            export(libs.decompose.core)
            export(libs.essenty.lifecycle)
            export(libs.essenty.backhandler)
            export(libs.moko.resources)
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(libs.forms)
                implementation(libs.kotlinx.datetime)
                implementation(libs.coroutines.core)
                api(libs.decompose.core)
                implementation(libs.bundles.ktor.shared)
                implementation(libs.ktorfit.lib)
                implementation(libs.bundles.replica.shared)
                implementation(libs.koin.core)
                implementation(libs.logger.kermit)
                api(libs.moko.resources)
                implementation(libs.forms)
            }
        }

        val androidMain by getting {
            dependencies {
                implementation(libs.forms)
                implementation(libs.coroutines.android)
                implementation(libs.ktor.android)
                implementation(libs.decompose.compose)
                implementation(libs.replica.androidNetwork)
                implementation(libs.moko.resourcesCompose)
                implementation(libs.bundles.compose)
                implementation(libs.coil)
                implementation(libs.activity)
                implementation(libs.accompanist.systemuicontroller)
                implementation(libs.security)
            }
        }

        val iosMain by getting {
            dependencies {
                implementation(libs.ktor.ios)
            }
        }
    }
}

android {
    val minSdkVersion = libs.versions.minSdkVersion.get().toInt()
    val targetSdkVersion = libs.versions.targetSdkVersion.get().toInt()

    namespace = "ru.mobileup.kmm_template"
    compileSdk = targetSdkVersion
    defaultConfig {
        minSdk = minSdkVersion
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    packaging {
        resources.excludes += "META-INF/*"
    }
}

dependencies {
    coreLibraryDesugaring(libs.android.desugar)
}

multiplatformResources {
    resourcesPackage.set("ru.mobileup.kmm_template")
}

// Usage: ./gradlew generateModuleGraph detectGraphCycles
moduleGraph {
    featuresPackage.set("ru.mobileup.kmm_template.features")
    featuresDirectory.set(project.file("src/commonMain/kotlin/ru/mobileup/kmm_template/features"))
    outputDirectory.set(project.file("module_graph"))
}