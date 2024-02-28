plugins {
    kotlin("multiplatform")
    id("com.android.library")
    id("dev.icerock.mobile.multiplatform-resources")
    id("io.gitlab.arturbosch.detekt")
}

@OptIn(org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi::class)
kotlin {
    targetHierarchy.default()

    androidTarget()

    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = "strings"
            isStatic = true
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                api(libs.moko.resources)
            }
        }
        val androidMain by getting {
            dependsOn(commonMain) // было добавлено чтобы решить эту проблему: https://stackoverflow.com/questions/72704714/kmm-project-expected-class-has-no-actual-declaration-in-module-for-jvm
        }

        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting
        val iosMain by getting {
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)
        }
    }
}

multiplatformResources {
    multiplatformResourcesPackage = "ru.mobileup.kmm_template"
}

android {
    val minSdkVersion: Int by rootProject.extra
    val targetSdkVersion: Int by rootProject.extra

    namespace = "ru.mobileup.kmm_template.strings"
    compileSdk = targetSdkVersion
    defaultConfig {
        minSdk = minSdkVersion
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    packaging {
        resources.excludes += "META-INF/*"
    }

    sourceSets.getByName("main") {
        res.srcDirs(
            // Workaround for Moko resources. See: https://github.com/icerockdev/moko-resources/issues/353#issuecomment-1179713713
            File(layout.buildDirectory.asFile.get(), "generated/moko/androidMain/res")
        )
    }
}

dependencies {
    coreLibraryDesugaring(libs.android.desugar)
}
