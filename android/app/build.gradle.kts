plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasKeystoreProperties = keystorePropertiesFile.exists()
if (hasKeystoreProperties) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.uzbapps.somchi"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (hasKeystoreProperties) {
                val storeFilePath = keystoreProperties.getProperty("storeFile")
                val storePwd = keystoreProperties.getProperty("storePassword")
                val keyAliasName = keystoreProperties.getProperty("keyAlias")
                val keyPwd = keystoreProperties.getProperty("keyPassword")

                if (storeFilePath == null || storePwd == null ||
                    keyAliasName == null || keyPwd == null) {
                    throw GradleException(
                        "key.properties to'liq emas — storeFile, storePassword, keyAlias, keyPassword kerak"
                    )
                }

                val resolvedStoreFile = file(storeFilePath)
                if (!resolvedStoreFile.exists()) {
                    throw GradleException(
                        "Keystore fayli topilmadi: ${resolvedStoreFile.absolutePath}"
                    )
                }

                keyAlias = keyAliasName
                keyPassword = keyPwd
                storeFile = resolvedStoreFile
                storePassword = storePwd
            }
        }
    }

    defaultConfig {
        applicationId = "com.uzbapps.somchi"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            if (hasKeystoreProperties) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Debug signing — faqat lokal sinov uchun. Release build uchun
                // key.properties majburiy.
                signingConfig = signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
