tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory.get())
}

plugins {
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.kotlin.multiplatform) apply false
    alias(libs.plugins.kotlin.serialization) apply false
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.ksp) apply false
    alias(libs.plugins.ktorfit) apply false
    alias(libs.plugins.moko.resources) apply false
    alias(libs.plugins.module.graph) apply false
    alias(libs.plugins.detekt) apply false

    alias(libs.plugins.convetion.lint) apply false
    alias(libs.plugins.convetion.detekt)
}
