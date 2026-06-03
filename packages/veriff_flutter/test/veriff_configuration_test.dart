import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

void main() {
  Configuration? configuration;

  tearDown(() {
    configuration = null;
  });

  test("Test Configuration is created with only sessionUrl", () async {
    String testSessionUrl = "test-url";
    configuration = Configuration(testSessionUrl);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], null);
    expect(configurationAsMap?['useCustomIntroScreen'], null);
    expect(configurationAsMap?['branding'], null);
    expect(configurationAsMap?['vendorData'], null);
  });

  test("Test Configuration is created with only languageLocale", () async {
    String testSessionUrl = "test-url";
    String testLanguageLocale = "test-locale";
    configuration =
        Configuration(testSessionUrl, languageLocale: testLanguageLocale);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], testLanguageLocale);
    expect(configurationAsMap?['useCustomIntroScreen'], null);
    expect(configurationAsMap?['branding'], null);
    expect(configurationAsMap?['vendorData'], null);
  });

  test("Test Configuration is created with only useCustomIntroScreen",
      () async {
    String testSessionUrl = "test-url";
    bool testUseCustomIntroScreen = true;
    configuration = Configuration(testSessionUrl,
        useCustomIntroScreen: testUseCustomIntroScreen);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], null);
    expect(
        configurationAsMap?['useCustomIntroScreen'], testUseCustomIntroScreen);
    expect(configurationAsMap?['branding'], null);
    expect(configurationAsMap?['vendorData'], null);
  });

  test("Test Configuration is created with only vendorData", () async {
    String testSessionUrl = "test-url";
    String testVendorData = "Vendor Data";
    configuration = Configuration(testSessionUrl, vendorData: testVendorData);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], null);
    expect(configurationAsMap?['useCustomIntroScreen'], null);
    expect(configurationAsMap?['branding'], null);
    expect(configurationAsMap?['vendorData'], testVendorData);
  });

  test("Test Configuration is created with null Branding", () async {
    String testSessionUrl = "test-url";
    Branding branding = Branding();
    configuration = Configuration(testSessionUrl, branding: branding);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], null);
    expect(configurationAsMap?['useCustomIntroScreen'], null);
    expect(configurationAsMap?['vendorData'], null);
    expect(configurationAsMap?['branding']['background'], null);
    expect(configurationAsMap?['branding']['logo'], null);
  });

  test("Test Configuration is created with Branding", () async {
    String testSessionUrl = "test-url";
    String testColor = "test-color";
    Branding branding = Branding(background: testColor);
    configuration = Configuration(testSessionUrl, branding: branding);
    Map? configurationAsMap = configuration?.asMap();
    expect(configurationAsMap?['sessionUrl'], testSessionUrl);
    expect(configurationAsMap?['languageLocale'], null);
    expect(configurationAsMap?['useCustomIntroScreen'], null);
    expect(configurationAsMap?['vendorData'], null);
    expect(configurationAsMap?['branding']['background'], testColor);
    expect(configurationAsMap?['branding']['onBackground'], null);
    expect(configurationAsMap?['branding']['logo'], null);
  });
}
