import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/src/branding.dart';
import 'package:veriff_flutter/src/fonts.dart';

void main() {
  Branding? branding;
  String imageResourceName = "test-image";

  tearDown(() {
    branding = null;
  });

  test("Test Branding is created with only background color", () async {
    String testBackgroundColor = "test-color";
    branding = Branding(background: testBackgroundColor);
    expect(branding?.background, testBackgroundColor);
    expect(branding?.onBackground, null);
    expect(branding?.onBackgroundSecondary, null);
    expect(branding?.onBackgroundTertiary, null);
    expect(branding?.primary, null);
    expect(branding?.onPrimary, null);
    expect(branding?.secondary, null);
    expect(branding?.onSecondary, null);
    expect(branding?.cameraOverlay, null);
    expect(branding?.onCameraOverlay, null);
    expect(branding?.outline, null);
    expect(branding?.error, null);
    expect(branding?.success, null);
    expect(branding?.buttonRadius, null);
    expect(branding?.fonts, null);
    expect(branding?.logo, null);
  });

  test("Test Branding is created with only buttonRadius", () async {
    int testButtonRadius = 5;
    branding = Branding(buttonRadius: testButtonRadius);
    expect(branding?.buttonRadius, testButtonRadius);
    expect(branding?.background, null);
    expect(branding?.onBackground, null);
    expect(branding?.onBackgroundSecondary, null);
    expect(branding?.onBackgroundTertiary, null);
    expect(branding?.primary, null);
    expect(branding?.onPrimary, null);
    expect(branding?.secondary, null);
    expect(branding?.onSecondary, null);
    expect(branding?.cameraOverlay, null);
    expect(branding?.onCameraOverlay, null);
    expect(branding?.outline, null);
    expect(branding?.error, null);
    expect(branding?.success, null);
    expect(branding?.fonts, null);
    expect(branding?.logo, null);
  });

  test("Test Branding is created correctly", () async {
    String testColor = "#ff0000";
    int testButtonRadius = 5;
    AssetImage? testAssetImage = AssetImage(imageResourceName);
    Fonts fonts = Fonts(regularFontPath: "regular", boldFontPath: "bold");
    branding = Branding(
        logo: testAssetImage,
        background: testColor,
        onBackground: testColor,
        onBackgroundSecondary: testColor,
        onBackgroundTertiary: testColor,
        primary: testColor,
        onPrimary: testColor,
        secondary: testColor,
        onSecondary: testColor,
        cameraOverlay: testColor,
        onCameraOverlay: testColor,
        outline: testColor,
        error: testColor,
        success: testColor,
        buttonRadius: testButtonRadius,
        fonts: fonts);
    expect(branding?.logo, testAssetImage);
    expect(branding?.background, testColor);
    expect(branding?.onBackground, testColor);
    expect(branding?.onBackgroundSecondary, testColor);
    expect(branding?.onBackgroundTertiary, testColor);
    expect(branding?.primary, testColor);
    expect(branding?.onPrimary, testColor);
    expect(branding?.secondary, testColor);
    expect(branding?.onSecondary, testColor);
    expect(branding?.outline, testColor);
    expect(branding?.cameraOverlay, testColor);
    expect(branding?.onCameraOverlay, testColor);
    expect(branding?.error, testColor);
    expect(branding?.success, testColor);
    expect(branding?.buttonRadius, testButtonRadius);
    expect(branding?.fonts, fonts);
  });

  test("Test Branding as map created correctly.", () async {
    int testButtonRadius = 5;
    branding = Branding(buttonRadius: testButtonRadius);
    Map? brandingAsMap = branding?.asMap();
    expect(brandingAsMap?['background'], null);
    expect(brandingAsMap?['onBackground'], null);
    expect(brandingAsMap?['onBackgroundSecondary'], null);
    expect(brandingAsMap?['onBackgroundTertiary'], null);
    expect(brandingAsMap?['primary'], null);
    expect(brandingAsMap?['onPrimary'], null);
    expect(brandingAsMap?['secondary'], null);
    expect(brandingAsMap?['onSecondary'], null);
    expect(brandingAsMap?['cameraOverlay'], null);
    expect(brandingAsMap?['onCameraOverlay'], null);
    expect(brandingAsMap?['outline'], null);
    expect(brandingAsMap?['error'], null);
    expect(brandingAsMap?['success'], null);
    expect(brandingAsMap?['buttonRadius'], testButtonRadius);
    expect(brandingAsMap?['logo'], null);
    expect(brandingAsMap?['font'], null);
  });

  test("Test Branding images as map created correctly with AssetImage.",
      () async {
    AssetImage? testLogo = AssetImage("test-image");
    branding = Branding(logo: testLogo);
    Map? brandingAsMap = branding?.asMap();
    expect(brandingAsMap?['logo'], "test-image");
  });
}
