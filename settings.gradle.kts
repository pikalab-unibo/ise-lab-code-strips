plugins {
    id("com.gradle.enterprise") version "3.9"
}

enableFeaturePreview("VERSION_CATALOGS")

dependencyResolutionManagement {
//    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
}

rootProject.name = "ise-lab-code-strips"
include("strips")

gradleEnterprise {
    buildScan {
        termsOfServiceUrl = "https://gradle.com/terms-of-service"
        termsOfServiceAgree = "yes"
        publishOnFailure()
    }
}
