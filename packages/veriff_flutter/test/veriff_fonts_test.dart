import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/src/fonts.dart';

void main() {
  Fonts? fonts;
  String regularFont = "test/regular.ttf";
  String mediumFont = "test/medium.ttf";
  String boldFont = "test/bold.ttf";

  tearDown(() {
    fonts = null;
  });

  test("Test Fonts is created with only regular font", () async {
    fonts = Fonts(regularFontPath: regularFont);
    expect(fonts?.regularFontPath, regularFont);
    expect(fonts?.mediumFontPath, null);
    expect(fonts?.boldFontPath, null);
  });

  test("Test Fonts as map created correctly.", () async {
    fonts = Fonts(
        regularFontPath: regularFont,
        mediumFontPath: mediumFont,
        boldFontPath: boldFont);

    Map? fontsAsMap = fonts?.asMap();
    expect(fontsAsMap?['regularFontPath'], regularFont);
    expect(fontsAsMap?['mediumFontPath'], mediumFont);
    expect(fontsAsMap?['boldFontPath'], boldFont);
  });
}
