allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter() // optional / deprecated
        maven(url = "https://jitpack.io")

        // Optional: Aliyun mirrors (fast in Asia)
        maven(url = "https://maven.aliyun.com/repository/google")
        maven(url = "https://maven.aliyun.com/repository/jcenter")
        maven(url = "https://maven.aliyun.com/repository/public")
        maven(url = "https://maven.aliyun.com/repository/gradle-plugin")
    }
}


buildscript {
    repositories {
        google()
        mavenCentral()
        jcenter() // optional / deprecated
        maven(url = "https://jitpack.io")

        // Optional: Aliyun mirrors (fast in Asia)
        maven(url = "https://maven.aliyun.com/repository/google")
        maven(url = "https://maven.aliyun.com/repository/jcenter")
        maven(url = "https://maven.aliyun.com/repository/public")
        maven(url = "https://maven.aliyun.com/repository/gradle-plugin")
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.4.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
