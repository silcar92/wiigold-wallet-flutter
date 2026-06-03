package com.veriff.veriff_flutter.helpers

import android.content.Context
import android.graphics.Color.parseColor
import com.veriff.Branding
import com.veriff.veriff_flutter.helpers.image.AssetIconProvider
import com.veriff.veriff_flutter.helpers.image.AssetLookup
import com.veriff.veriff_flutter.helpers.image.NetworkIconProvider
import java.util.*


private const val KEY_SESSION_URL = "sessionUrl"
private const val KEY_LOCALE = "languageLocale"
private const val KEY_BRANDING = "branding"
private const val KEY_CUSTOM_INTRO = "useCustomIntroScreen"
private const val KEY_VENDOR_DATA = "vendorData"

private const val KEY_BACKGROUND = "background"
private const val KEY_ON_BACKGROUND = "onBackground"
private const val KEY_ON_BACKGROUND_SECONDARY = "onBackgroundSecondary"
private const val KEY_ON_BACKGROUND_TERTIARY = "onBackgroundTertiary"
private const val KEY_PRIMARY = "primary"
private const val KEY_ON_PRIMARY = "onPrimary"
private const val KEY_SECONDARY = "secondary"
private const val KEY_ON_SECONDARY = "onSecondary"
private const val KEY_CAMERA_OVERLAY = "cameraOverlay"
private const val KEY_ON_CAMERA_OVERLAY = "onCameraOverlay"
private const val KEY_OUTLINE = "outline"
private const val KEY_SUCCESS = "success"
private const val KEY_ERROR = "error"
private const val KEY_BUTTON_RADIUS = "buttonRadius"
private const val KEY_LOGO = "logo"

fun <V> Map<String, V>.toFlutterConfig(
    context: Context,
    assetLookup: AssetLookup
): FlutterConfiguration? {
    val sessionUrl: String
    if (this.containsKey(KEY_SESSION_URL) && this[KEY_SESSION_URL] is String)
        sessionUrl = this[KEY_SESSION_URL] as String
    else
        return null

    var locale: Locale? = null
    if (this[KEY_LOCALE] != null && this[KEY_LOCALE] is String) {
        locale = Locale(this[KEY_LOCALE] as String)
    }

    var branding: Map<String, Any>? = null
    if (this.containsKey(KEY_BRANDING) && this[KEY_BRANDING] is Map<*, *>) {
        branding = this[KEY_BRANDING] as Map<String, Any>
    }

    var useCustomIntro = false
    if (this[KEY_CUSTOM_INTRO] != null && this[KEY_CUSTOM_INTRO] is Boolean) {
        useCustomIntro = this[KEY_CUSTOM_INTRO] as Boolean
    }

    var vendorData: String? = null
    if (this[KEY_VENDOR_DATA] != null && this[KEY_VENDOR_DATA] is String) {
        vendorData = this[KEY_VENDOR_DATA] as String
    }

    return FlutterConfiguration(
        sessionUrl = sessionUrl,
        branding = branding?.toVeriffBranding(context, assetLookup),
        languageLocale = locale,
        useCustomIntroScreen = useCustomIntro,
        vendorData = vendorData
    )
}

private fun <V> Map<String, V>.toVeriffBranding(
    context: Context,
    assetLookup: AssetLookup
): Branding? {
    val builder = Branding.Builder()

    if (this.containsKey(KEY_BACKGROUND) && this[KEY_BACKGROUND].isStringAndNotEmpty()) {
        builder.background(parseColor(this[KEY_BACKGROUND] as String))
    }

    if (this.containsKey(KEY_ON_BACKGROUND) && this[KEY_ON_BACKGROUND].isStringAndNotEmpty()) {
        builder.onBackground(parseColor(this[KEY_ON_BACKGROUND] as String))
    }

    if (this.containsKey(KEY_ON_BACKGROUND_SECONDARY) && this[KEY_ON_BACKGROUND_SECONDARY].isStringAndNotEmpty()) {
        builder.onBackgroundSecondary(parseColor(this[KEY_ON_BACKGROUND_SECONDARY] as String))
    }

    if (this.containsKey(KEY_ON_BACKGROUND_TERTIARY) && this[KEY_ON_BACKGROUND_TERTIARY].isStringAndNotEmpty()) {
        builder.onBackgroundTertiary(parseColor(this[KEY_ON_BACKGROUND_TERTIARY] as String))
    }

    if (this.containsKey(KEY_PRIMARY) && this[KEY_PRIMARY].isStringAndNotEmpty()) {
        builder.primary(parseColor(this[KEY_PRIMARY] as String))
    }

    if (this.containsKey(KEY_ON_PRIMARY) && this[KEY_ON_PRIMARY].isStringAndNotEmpty()) {
        builder.onPrimary(parseColor(this[KEY_ON_PRIMARY] as String))
    }

    if (this.containsKey(KEY_SECONDARY) && this[KEY_SECONDARY].isStringAndNotEmpty()) {
        builder.secondary(parseColor(this[KEY_SECONDARY] as String))
    }

    if (this.containsKey(KEY_ON_SECONDARY) && this[KEY_ON_SECONDARY].isStringAndNotEmpty()) {
        builder.onSecondary(parseColor(this[KEY_ON_SECONDARY] as String))
    }

    if (this.containsKey(KEY_CAMERA_OVERLAY) && this[KEY_CAMERA_OVERLAY].isStringAndNotEmpty()) {
        builder.cameraOverlay(parseColor(this[KEY_CAMERA_OVERLAY] as String))
    }

    if (this.containsKey(KEY_ON_CAMERA_OVERLAY) && this[KEY_ON_CAMERA_OVERLAY].isStringAndNotEmpty()) {
        builder.onCameraOverlay(parseColor(this[KEY_ON_CAMERA_OVERLAY] as String))
    }

    if (this.containsKey(KEY_OUTLINE) && this[KEY_OUTLINE].isStringAndNotEmpty()) {
        builder.outline(parseColor(this[KEY_OUTLINE] as String))
    }

    if (this.containsKey(KEY_SUCCESS) && this[KEY_SUCCESS].isStringAndNotEmpty()) {
        builder.success(parseColor(this[KEY_SUCCESS] as String))
    }

    if (this.containsKey(KEY_ERROR) && this[KEY_ERROR].isStringAndNotEmpty()) {
        builder.error(parseColor(this[KEY_ERROR] as String))
    }

    if (this.containsKey(KEY_BUTTON_RADIUS) && this[KEY_BUTTON_RADIUS] is Number) {
        builder.buttonRadius((this[KEY_BUTTON_RADIUS] as Number).toFloat())
    }

    if (this.containsKey(KEY_LOGO) && this[KEY_LOGO].isStringAndNotEmpty()) {
        val url = this[KEY_LOGO] as String
        if (isNetworkAsset(url = url)) {
            //this is not used as long as we only support AssetImage from flutter side
            builder.logo(NetworkIconProvider(url))
        } else {
            builder.logo(AssetIconProvider(assetLookup.getLookupKeyForAsset(url)))
        }
    }

    return builder.build()
}

private fun Any?.isStringAndNotEmpty(): Boolean {
    return this is String && this.isNotBlank() && this.isNotEmpty()
}

private fun isNetworkAsset(url: String): Boolean {
    return url.startsWith("https://") || url.startsWith("http://") || url.startsWith("file://")
}
