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
}