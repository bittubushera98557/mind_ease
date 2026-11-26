# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# Stripe & React Native Stripe SDK Rules
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.stripe.android.**
-dontwarn com.reactnativestripesdk.**
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Zoom Video SDK Rules
-dontwarn javax.lang.model.**
-dontwarn us.zoom.**
-dontwarn com.zipow.**
-keep class us.zoom.** { *; }
-keep class com.zipow.** { *; }

# General Annotations & Model Rules
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
