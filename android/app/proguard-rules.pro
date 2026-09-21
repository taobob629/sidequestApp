# Preserve native method names used through JNI.
-keepclasseswithmembernames class * {
    native <methods>;
}

# The locally bundled Alipay+ client is integrated as a flat AAR and cannot
# contribute reliable dependency metadata. Preserve its public bridge classes.
-keep class com.iap.alipayplusclient.** { *; }
-keep interface com.iap.alipayplusclient.** { *; }

# Preserve payment callbacks invoked by the Alipay SDK.
-keep class com.alipay.** { *; }
-keep interface com.alipay.** { *; }

# Preserve WeChat SDK entry points used from Android intents/callbacks.
-keep class com.tencent.mm.opensdk.** { *; }
-keep interface com.tencent.mm.opensdk.** { *; }

# Retain annotations and generic signatures used by SDK serializers.
-keepattributes RuntimeVisibleAnnotations,RuntimeInvisibleAnnotations,AnnotationDefault,Signature,InnerClasses,EnclosingMethod

# AndroidX WindowManager probes these optional OEM extension APIs at runtime.
-dontwarn androidx.window.extensions.WindowExtensions
-dontwarn androidx.window.extensions.WindowExtensionsProvider
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaPresentation
-dontwarn androidx.window.extensions.layout.DisplayFeature
-dontwarn androidx.window.extensions.layout.FoldingFeature
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.extensions.layout.WindowLayoutInfo
-dontwarn androidx.window.sidecar.SidecarDeviceState
-dontwarn androidx.window.sidecar.SidecarDisplayFeature
-dontwarn androidx.window.sidecar.SidecarInterface$SidecarCallback
-dontwarn androidx.window.sidecar.SidecarInterface
-dontwarn androidx.window.sidecar.SidecarProvider
-dontwarn androidx.window.sidecar.SidecarWindowLayoutInfo

# Stripe's optional push-provisioning module is not used by this app.
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
