plugins {
    alias(libs.plugins.kotlin.jvm)
}

allprojects {
    repositories {
        mavenCentral()
    }
}

dependencies {
    implementation(libs.tuprolog.ide)
    implementation(libs.tuprolog.repl)
}

listOf("gui", "repl").forEach {
    task<JavaExec>("runTuprolog${it.toUpperCase()}") {
        group = "tuprolog"
        mainClass.set("it.unibo.tuprolog.ui.$it.Main")
        sourceSets.main { classpath = runtimeClasspath }
        standardInput = System.`in`
    }
}
