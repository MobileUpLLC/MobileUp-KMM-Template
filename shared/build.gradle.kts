plugins {
    kotlin("multiplatform")
    kotlin("plugin.serialization")
    id("com.android.library")
    id("com.google.devtools.ksp")
    id("de.jensklingenberg.ktorfit")
    kotlin("plugin.parcelize")
    id("ru.mobileup.module-graph")
    id("io.gitlab.arturbosch.detekt")
}

kotlin {
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
            export(project(":strings"))
            export(libs.moko.resources)
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                api(project(":strings"))

                // на время убрано по вот этой причине: https://github.com/icerockdev/moko-resources/issues/476
                // implementation(libs.forms)
                implementation(libs.kotlinx.datetime)
                implementation(libs.coroutines.core)
                api(libs.decompose.core)
                implementation(libs.bundles.ktor.shared)
                implementation(libs.ktorfit.lib)
                implementation(libs.bundles.replica.shared)
                implementation(libs.koin.core)
                implementation(libs.logger.kermit)
            }
        }

        val androidMain by getting {
            dependsOn(commonMain) // было добавлено чтобы решить эту проблему: https://stackoverflow.com/questions/72704714/kmm-project-expected-class-has-no-actual-declaration-in-module-for-jvm
            dependencies {
                // на время убрано по вот этой причине: https://github.com/icerockdev/moko-resources/issues/476
                // implementation(libs.forms)
                implementation(libs.coroutines.android)
                implementation(libs.ktor.android)
                implementation(libs.decompose.compose)
                implementation(libs.replica.androidNetwork)
                implementation(libs.moko.resourcesCompose)
                implementation(libs.bundles.compose)
                implementation(libs.bundles.accompanist)
                implementation(libs.coil)
                implementation(libs.activity)
            }
        }

        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting
        val iosMain by creating {
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)

            dependencies {
                implementation(libs.ktor.ios)
            }
        }
    }
}

android {
    val minSdkVersion: Int by rootProject.extra
    val targetSdkVersion: Int by rootProject.extra

    namespace = "ru.mobileup.kmm_template"
    compileSdk = targetSdkVersion
    defaultConfig {
        minSdk = minSdkVersion
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = libs.versions.composeCompiler.get()
    }

    packaging {
        resources.excludes += "META-INF/*"
    }
}

dependencies {
    coreLibraryDesugaring(libs.android.desugar)
    add("kspCommonMainMetadata", libs.ktorfit.ksp)
    add("kspAndroid", libs.ktorfit.ksp)
    add("kspIosX64", libs.ktorfit.ksp)
    add("kspIosArm64", libs.ktorfit.ksp)
    add("kspIosSimulatorArm64", libs.ktorfit.ksp)
}

// Usage: ./gradlew generateModuleGraph detectGraphCycles
moduleGraph {
    featuresPackage.set("ru.mobileup.kmm_template.features")
    featuresDirectory.set(project.file("src/commonMain/kotlin/ru/mobileup/kmm_template/features"))
    outputDirectory.set(project.file("module_graph"))
}