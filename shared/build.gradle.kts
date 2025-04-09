import co.touchlab.skie.configuration.DefaultArgumentInterop
import co.touchlab.skie.configuration.EnumInterop
import co.touchlab.skie.configuration.FlowInterop
import co.touchlab.skie.configuration.FunctionInterop
import co.touchlab.skie.configuration.SealedInterop
import co.touchlab.skie.configuration.SuspendInterop
import io.gitlab.arturbosch.detekt.Detekt

plugins {
    alias(libs.plugins.kotlin.multiplatform)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.android.library)
    alias(libs.plugins.ksp)
    alias(libs.plugins.ktorfit)
    alias(libs.plugins.moko.resources)
    alias(libs.plugins.module.graph)
    alias(libs.plugins.detekt)
    alias(libs.plugins.jetbrains.compose)
    alias(libs.plugins.compose.compiler)
    alias(libs.plugins.skie)
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
                implementation(libs.form.validation)
                implementation(libs.kotlinx.datetime)
                implementation(libs.coroutines.core)
                api(libs.decompose.core)
                implementation(libs.bundles.ktor.shared)
                implementation(libs.ktorfit.lib)
                implementation(libs.bundles.replica.shared)
                implementation(libs.koin)
                implementation(libs.logger.kermit)
                api(libs.moko.resources)
                implementation(libs.form.validation)
            }
        }

        val androidMain by getting {
            dependencies {
                implementation(libs.form.validation)
                implementation(libs.coroutines.android)
                implementation(libs.ktor.android)
                implementation(libs.decompose.compose)
                implementation(libs.replica.android.network)
                implementation(libs.moko.resourcesCompose)
                implementation(project.dependencies.platform(libs.compose.bom))
                implementation(libs.bundles.compose)
                implementation(libs.coil)
                implementation(libs.accompanist.systemuicontroller)
            }
        }

        val iosMain by getting {
            dependencies {
                implementation(libs.ktor.ios)
                implementation(compose.runtime)
            }
        }
    }
}

android {
    val minSdkVersion = libs.versions.minSdk.get().toInt()
    val compileSdkVersion = libs.versions.compileSdk.get().toInt()

    namespace = "ru.mobileup.kmm_template"
    compileSdk = compileSdkVersion
    defaultConfig {
        minSdk = minSdkVersion
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    packaging {
        resources.excludes += "META-INF/*"
    }
}

skie {
    features {
        group {
            EnumInterop.Enabled(true)
            SealedInterop.Enabled(true)
            DefaultArgumentInterop.Enabled(true)
            FunctionInterop.FileScopeConversion.Enabled(true)
            coroutinesInterop.set(true)
            SuspendInterop.Enabled(true)
            FlowInterop.Enabled(true)
        }
    }
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