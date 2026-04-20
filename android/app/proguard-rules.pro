# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Google Play Services
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes SourceFile,LineNumberTable

# App BuildConfig (versionName / versionCode ni saqlash)
-keep class com.uzbapps.somchi.BuildConfig { *; }

# Shared Preferences
-keep class androidx.datastore.** { *; }

# AndroidX
-keep class androidx.lifecycle.** { *; }
-keep class androidx.core.** { *; }
-dontwarn androidx.**

# Kotlin
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# Google Play Core (required by Flutter for deferred components)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keep class com.google.android.play.core.** { *; }

# Exception bilan bog'liq maydonlarni saqlab qolish (stack trace uchun)
-keepattributes Exceptions

# Parcelable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
