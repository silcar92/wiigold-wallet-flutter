import 'package:flutter/material.dart';
import 'fonts.dart';

/// Contains branding options available for Veriff.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
class Branding {
  /// Asset key string for custom logo to replace Veriff logos.
  AssetImage? logo;

  /// Screen and dialog background
  String? background;

  /// Non-surface content (such as text, icons) displayed on the background color
  String? onBackground;

  /// Secondary non-surface content (such as text) displayed on the background color
  String? onBackgroundSecondary;

  /// Tertiary non-surface content (such as text) displayed on the background color
  String? onBackgroundTertiary;

  /// Primary surfaces (such as buttons) displayed on the background color
  String? primary;

  /// Non-surface content (such as text) displayed on primary surfaces
  String? onPrimary;

  /// Secondary surfaces (such as bullet points and illustrations) displayed on the background color
  String? secondary;

  /// Non-surface content (such as text) displayed on secondary surfaces
  String? onSecondary;

  /// Backgroung color of the overlay area on all the screens with camera
  String? cameraOverlay;

  /// All UI elements on all the screens with camera on top of camera overlay
  /// Accessibility: Must have a contrast ratio of at least 4.5:1 vs `cameraOverlay`
  String? onCameraOverlay;

  /// Outlines and boundaries of UI elements (such as text inputs)
  String? outline;

  /// Error indicators (such as text, borders, icons) displayed on background color
  String? error;

  /// Success indicators (such as borders, icons) displayed on background color
  String? success;

  /// Corner radius value for buttons.
  int? buttonRadius;

  /// [Fonts] object for customising the fonts
  Fonts? fonts;

  /// Creates a [Branding] object.
  Branding(
      {AssetImage? logo,
      String? background,
      String? onBackground,
      String? onBackgroundSecondary,
      String? onBackgroundTertiary,
      String? primary,
      String? onPrimary,
      String? secondary,
      String? onSecondary,
      String? cameraOverlay,
      String? onCameraOverlay,
      String? outline,
      String? error,
      String? success,
      int? buttonRadius,
      Fonts? fonts}) {
    this.logo = logo;
    this.background = background;
    this.onBackground = onBackground;
    this.onBackgroundSecondary = onBackgroundSecondary;
    this.onBackgroundTertiary = onBackgroundTertiary;
    this.primary = primary;
    this.onPrimary = onPrimary;
    this.secondary = secondary;
    this.onSecondary = onSecondary;
    this.cameraOverlay = cameraOverlay;
    this.onCameraOverlay = onCameraOverlay;
    this.outline = outline;
    this.error = error;
    this.success = success;
    this.buttonRadius = buttonRadius;
    this.fonts = fonts;
  }

  /// Returns the [Branding] object as map.
  Map<String, dynamic> asMap() {
    Map<String, dynamic>? fontsMap;
    if (this.fonts != null) fontsMap = this.fonts!.asMap();
    return {
      "logo": this.logo != null ? this.logo!.keyName : null,
      "background": this.background,
      "onBackground": this.onBackground,
      "onBackgroundSecondary": this.onBackgroundSecondary,
      "onBackgroundTertiary": this.onBackgroundTertiary,
      "primary": this.primary,
      "onPrimary": this.onPrimary,
      "secondary": this.secondary,
      "onSecondary": this.onSecondary,
      "cameraOverlay": this.cameraOverlay,
      "onCameraOverlay": this.onCameraOverlay,
      "outline": this.outline,
      "error": this.error,
      "success": this.success,
      "buttonRadius": this.buttonRadius,
      "font": fontsMap
    };
  }
}
