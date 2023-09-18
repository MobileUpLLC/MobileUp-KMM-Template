val minSdkVersion by extra(23)
val targetSdkVersion by extra(34)

plugins {
    // пришлось перенести сюда из-за вот этой проблемы: https://youtrack.jetbrains.com/issue/KT-46200
    val kotlinVersion = "1.9.10"
    val androidPluginVersion = "8.1.1"
    val kspVersion = "1.9.10-1.0.13"
    val ktorfitVersion = "1.7.0"
    val mokoResourcesVersion = "0.23.0"
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

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory.asFile.get())
}

subprojects {
    afterEvaluate {
        apply {
            from("$rootDir/code_quality/lint/lint.gradle")
            from("$rootDir/code_quality/detekt/detekt.gradle")
        }
    }
}