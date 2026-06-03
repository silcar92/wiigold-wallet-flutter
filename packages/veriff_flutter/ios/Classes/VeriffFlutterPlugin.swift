import Flutter
import UIKit
import Veriff

public class VeriffFlutterPlugin: NSObject, FlutterPlugin {

    var veriff: VeriffSdk?
    var delegate: VeriffSdkDelegate?
    var registrar: FlutterPluginRegistrar?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.veriff.flutter", binaryMessenger: registrar.messenger())
        let instance = VeriffFlutterPlugin()
        instance.veriff = VeriffSdk.shared
        instance.veriff?.implementationType = .flutter
        instance.registrar = registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "veriffStart" {
            guard let arguments = call.arguments as? [String: Any],
                  let sessionUrl = arguments["sessionUrl"] as? String else {
                print("No sessionUrl is passed.")
                return
            }
            var veriffBranding: VeriffSdk.Branding?
            if let brandingDict = arguments["branding"] as? [String: Any] {
                let branding = VeriffSdk.Branding()
                branding.logo = brandingDict.image(for: "logo", registrar: registrar)
                branding.background = brandingDict.color(for: "background")
                branding.onBackground = brandingDict.color(for: "onBackground")
                branding.onBackgroundSecondary = brandingDict.color(for: "onBackgroundSecondary")
                branding.onBackgroundTertiary = brandingDict.color(for: "onBackgroundTertiary")
                branding.primary = brandingDict.color(for: "primary")
                branding.onPrimary = brandingDict.color(for: "onPrimary")
                branding.secondary = brandingDict.color(for: "secondary")
                branding.onSecondary = brandingDict.color(for: "onSecondary")
                branding.cameraOverlay = brandingDict.color(for: "cameraOverlay")
                branding.onCameraOverlay = brandingDict.color(for: "onCameraOverlay")
                branding.outline = brandingDict.color(for: "outline")
                branding.error = brandingDict.color(for: "error")
                branding.success = brandingDict.color(for: "success")
                branding.buttonRadius = (brandingDict["buttonRadius"] as? Double).map { CGFloat($0) }
                branding.font = loadFonts(brandingDict: brandingDict)
                veriffBranding = branding
            }
            var languageLocale: Locale?
            if let localeIdentifier = arguments["languageLocale"] as? String {
                languageLocale = Locale(identifier: localeIdentifier)
            }
            let configuration = VeriffSdk.Configuration(branding: veriffBranding, languageLocale: languageLocale)
            if let useCustomIntro = arguments["useCustomIntroScreen"] as? Bool {
                configuration.customIntroScreen = useCustomIntro
            }
            configuration.vendorData = arguments["vendorData"] as? String
            DispatchQueue.main.async {
                self.delegate = VeriffSdkDelegate(flutterResult: result)  // keeping a strong reference to a delegate
                self.veriff?.delegate = self.delegate
                self.veriff?.startAuthentication(sessionUrl: sessionUrl, configuration: configuration)
            }
        }
    }

    private func loadFonts(brandingDict: [String: Any]) -> VeriffSdk.Branding.Font? {
        guard
            let fontDict = brandingDict["font"] as? [String: String],
            let regularFontPath = fontDict["regularFontPath"],
            let mediumFontPath = fontDict["mediumFontPath"],
            let boldFontPath = fontDict["boldFontPath"],
            let regularFontName = loadFont(assetKey: regularFontPath),
            let mediumFontName = loadFont(assetKey: mediumFontPath),
            let boldFontName = loadFont(assetKey: boldFontPath)
        else { return nil }
        return .init(
            regular: regularFontName,
            medium: mediumFontName,
            bold: boldFontName
        )
    }
    
    /// Registers graphics font
    /// - Parameter assetKey: Font path
    /// - Returns: Font name
    private func loadFont(assetKey: String) -> String? {
        guard
            let key = registrar?.lookupKey(forAsset: assetKey),
            let fontURL = Bundle.main.url(forResource: key, withExtension: nil)
        else {
            print("Veriff plugin can't locate the font path for given key: \(assetKey)")
            return nil
        }
        do {
            let fontData = try Data(contentsOf: fontURL)
            guard
                let dataProvider = CGDataProvider(data: fontData as CFData),
                let fontRef = CGFont(dataProvider),
                CTFontManagerRegisterGraphicsFont(fontRef, nil)
            else {
                print("Veriff plugin can't load the font by URL: \(fontURL)")
                return nil
            }
            return fontRef.postScriptName as String?
        } catch {
            print("Veriff plugin failed to load font data by url \(fontURL) with error: \(error)")
            return nil
        }
    }
}

class VeriffSdkDelegate: Veriff.VeriffSdkDelegate {
    let flutterResult: FlutterResult

    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
    }

    public func sessionDidEndWithResult(_ result: VeriffSdk.Result) {
        let (status, statusString) = resultToFlutter(result: result)
        let resultDict: [String: Any] = ["status": status, "error": statusString]
        flutterResult(resultDict)
    }

    private func resultToFlutter(result: VeriffSdk.Result) -> (Int, String) {
        switch result.status {
        case .done:
            return (1, "none")
        case .canceled:
            return (0, "none")
        case .error(let err):
            switch err {
            case .cameraUnavailable:
                return (-1, "cameraUnavailable")
            case .microphoneUnavailable:
                return (-1, "microphoneUnavailable")
            case .networkError,
                 .uploadError:
                return (-1, "networkError")
            case .serverError,
                 .videoFailed,
                 .localError:
                return (-1, "sessionError")
            case .unknown:
                return (-1, "unknown")
            case .deprecatedSDKVersion:
                return (-1, "deprecatedSDKVersion")
            default:
                return (-3, "")
            }
        default:
            return (-3, "")
        }
    }
}

private extension Dictionary where Key == String, Value == Any {
    func image(for key: String, registrar: FlutterPluginRegistrar?) -> UIImage? {
        guard let assetKey = self[key] as? String else { return nil }
        let key = registrar?.lookupKey(forAsset: assetKey)
        guard let path = Bundle.main.path(forResource: key, ofType: nil) else {
            print("Veriff plugin can't locate the image path for given key: \(key ?? "nil")")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }

    func color(for key: String) -> UIColor? {
        guard var hexcolor = self[key] as? String else { return nil }
        if hexcolor.starts(with: "#") {
            hexcolor = String(hexcolor.dropFirst())
        }
        var color: UInt64 = 0
        Scanner(string: hexcolor).scanHexInt64(&color)
        var a: CGFloat = 1
        if hexcolor.count > 7 {
            // #rrggbbaa
            a = CGFloat(color & 0xff) / 255.0
            color = color >> 8
        }
        let r = CGFloat((color >> 16) & 0xff) / 255.0
        let g = CGFloat((color >> 8) & 0xff) / 255.0
        let b = CGFloat(color & 0xff) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
