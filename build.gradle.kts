val minSdkVersion by extra(23)
val targetSdkVersion by extra(34)

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

plugins {
    val kotlinVersion = "1.9.22"
    val androidPluginVersion = "8.1.1"
    val kspVersion = "1.9.22-1.0.16"
    val ktorfitVersion = "1.12.0"
    val mokoResourcesVersion = "0.24.0-alpha-5"
    val moduleGraphVersion = "1.3.3"
    val detektVersion = "1.23.1"

    kotlin("android") version kotlinVersion apply false
    kotlin("multiplatform") version kotlinVersion apply false
    kotlin("plugin.serialization") version kotlinVersion apply false
    kotlin("plugin.parcelize") version kotlinVersion apply false
    id("com.android.application") version androidPluginVersion apply false
    id("com.android.library") version androidPluginVersion apply false
    id("com.google.devtools.ksp") version kspVersion apply false
    id("de.jensklingenberg.ktorfit") version ktorfitVersion apply false
    id("dev.icerock.mobile.multiplatform-resources") version mokoResourcesVersion apply false
    id("ru.mobileup.module-graph") version moduleGraphVersion apply false
    id("io.gitlab.arturbosch.detekt") version detektVersion apply false
}

subprojects {
    afterEvaluate {
        apply {
            from("$rootDir/code_quality/lint/lint.gradle")
            from("$rootDir/code_quality/detekt/detekt.gradle")
        }
    }
}