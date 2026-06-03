/// Contains font configuration options available for Veriff.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
class Fonts {
  /// All paths are relative to the Flutter project

  /// Path to regular font file (example: "fonts/regular.ttf")
  String? regularFontPath;

  /// Path to medium font file (example: "fonts/medium.ttf")
  String? mediumFontPath;

  /// Path to bold font file (example: "fonts/bold.ttf")
  String? boldFontPath;

  /// Creates a [Fonts] object.
  Fonts(
      {String? regularFontPath, String? mediumFontPath, String? boldFontPath}) {
    this.regularFontPath = regularFontPath;
    this.mediumFontPath = mediumFontPath;
    this.boldFontPath = boldFontPath;
  }

  /// Returns the [Fonts] object as map.
  Map<String, dynamic> asMap() {
    return {
      "regularFontPath": this.regularFontPath,
      "mediumFontPath": this.mediumFontPath,
      "boldFontPath": this.boldFontPath
    };
  }
}
