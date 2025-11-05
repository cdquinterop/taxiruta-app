# Flutter Secure Storage ProGuard rules
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class com.it_nomads.fluttersecurestorage.ciphers.** { *; }
-keep class com.it_nomads.fluttersecurestorage.ciphers.StorageCipherFactory { *; }

# Keep all classes and methods in the flutter secure storage package
-keep class * extends com.it_nomads.fluttersecurestorage.ciphers.StorageCipher { *; }

# Prevent obfuscation of classes that are used via reflection
-keepclassmembers class * {
    @com.it_nomads.fluttersecurestorage.** <methods>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all constructors
-keepclassmembers class * {
    public <init>(...);
}

# Gson specific classes for serialization
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep all Flutter plugins
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# OkHttp
-keep class okhttp3.** { *; }
-keep class okio.** { *; }