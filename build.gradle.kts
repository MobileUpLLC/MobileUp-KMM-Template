tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory.get())
}

plugins {
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.kotlin.multiplatform) apply false
    alias(libs.plugins.kotlin.plugin.serialization) apply false
    alias(libs.plugins.kotlin.plugin.parcelize) apply false
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.ksp) apply false
    alias(libs.plugins.ktorfit) apply false
    alias(libs.plugins.mokoResources) apply false
    alias(libs.plugins.moduleGraph) apply false
    alias(libs.plugins.detekt) apply false
}

subprojects {
    afterEvaluate {
        apply {
            from("$rootDir/code_quality/lint/lint.gradle")
            from("$rootDir/code_quality/detekt/detekt.gradle")
        }
    }
}