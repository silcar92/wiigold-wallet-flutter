# veriff_flutter

Flutter plugin for [Veriff](https://www.veriff.com/).

### Requirements

Integration with Veriff Flutter Plugin requires the project to target at least iOS version 13.0 and Android version 8.0 (api 26) or higher.

### Add plugin to a project

Add the Veriff Flutter Plugin to your `pubspec.yaml` file:

```yaml
dependencies:
      veriff_flutter
```

### iOS specific configuration

#### Add usage descriptions to application Info.plist

> Not adding these usage descriptions causes system to kill application when it requests the permissions when needed.

Veriff requires camera, microphone, photo library and optionally NFC reader permissions for capturing photos, video and scanning passport during identification. Your application is responsible to describe the reason why camera, microphone, photo library and NFC reader is used. You must add 3 descriptions listed below to ```Info.plist``` of your application with the explanation of the usage.

- `NSCameraUsageDescription`
- `NSMicrophoneUsageDescription`
- `NSPhotoLibraryUsageDescription`

#### Add required steps for NFC scanning

1. Add `NFCReaderUsageDescription` description to ```Info.plist```.
2. The application needs to define the list of application IDs or AIDs it can connect to, in the Info.plist file. The AID is a way of uniquely identifying an application on a ISO 7816 tag, which is usually defined by a standard.

    ```
    <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
    <array>
      <string>A0000002471001</string>
      <string>A0000002472001</string>
      <string>00000000000000</string>
    </array>
    ```
3. Add a new entitlement for NFC scanning. This new entitlement is added automatically by Xcode when enabling the Near Field Communication Tag Reading capability in the target Signing & Capabilities. After enabling the capability the *.entitlements file needs to contain the TAG format:

    ```
    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>TAG</string>
    </array>
    ```

#### Set the iOS target in Xcode

Make sure that the 'iOS Deployment Target' in Xcode (under Project > target > Info > Deployment Target) is set to iOS `13.0` or later.

### Starting verification flow

#### Import plugin in your code

In order to use Veriff plugin, please import it to your class that will use it.
```
import 'package:veriff_flutter/veriff_flutter.dart'
```

#### Start verification flow
In order to start the verification flow please create a configuration with sessionUrl you receive from your backend implementation[Required].

```
Configuration config = Configuration(sessionUrl);
```

Then pass the configuration to Veriff object and start the verification flow;

```
Veriff veriff = Veriff();

try {
      Result result = await veriff.start(config);
      print(result.status);
      print(result.error);
    } on PlatformException {
      // handle exception
    }
```

#### Customize user interface (Optional)
You can customize Veriff SDK user interface in your application by defining your brand main color and logo.

See the <a href="/images/Veriff-SDK-Customization.pdf" target=“_blank” >Veriff SDK customization guide</a> document to see what it looks like.

Veriff Flutter plugin allows the customization of your brand's colors, font and logo in the SDK flow by passing the optional parameters when launching Veriff;

```
String regularFontPath = "fonts/Regular.otf";
String mediumFontPath = "fonts/Medium.otf";
String boldFontPath = "fonts/Bold.otf";
Fonts fonts = Fonts(
    regularFontPath: regularFontPath, 
    mediumFontPath: mediumFontPath, 
    boldFontPath: boldFontPath
);
Branding branding = Branding(
    logo: AssetImage(path_of_image),
    background: "#f2ff00",
    onBackground: "#ff00ff",
    onBackgroundSecondary: "#52b35c",
    onBackgroundTertiary: "#3a593d",
    primary: "#123abc",
    onPrimary: "#ff00ff",
    secondary: "#f2ff00",
    onSecondary: "#ff7700",
    cameraOverlay: "#59496a",
    onCameraOverlay: "#e27e23",
    outline: "#ff00ff",
    error: "#ff0000",
    success: "#00ff00",
    buttonRadius: 5,
    fonts: fonts
);
```

And pass the branding object with configuration for starting the verification flow;

```
Configuration config = Configuration(sessionUrl, branding: branding);
```

When a color isn't defined, the default Veriff theme color is used.

#### Setting the user interface language

Veriff Flutter plugin supports setting the language of the UI. In order to use this feature, please pass the locale identifier as in example below;

```
Configuration config = Configuration(sessionUrl, branding: branding, languageLocale: "et");
```

#### Custom intro screen
Veriff supports replacing introduction screen with a custom client developed introduction screen for eligible clients. First, please ask about this possibility from your account manager. In case we can offer it for you then removal process is following:

- You agree your own introduction screen visuals and copy with our account manager and get relevant legal documents signed in case their needed.
- After that Veriff will enable custom introduction screen from backend for your integrations.
- After you have implemented your own introduction screen you can change the configuration option specified below.

```
config.useCustomIntroScreen = true;
```

### Vendor data

Veriff supports the option to override vendor data. Please check with your **Solutions Engineer** to confirm if this feature can be enabled for your integration. If it is possible, follow these steps:

1. Veriff will enable vendor data overriding from the backend for your integrations.
2. Modify the configuration option as specified below.

```
config.vendorData = "Vendor Data";
```

#### Handling the results from plugin
The Result returned by start method will have a status that is one of `Status.done`, `Status.canceled` and `Status.error`.
In case Status.error is received, you will also have an error description that is one of the list below;

- Error.cameraUnavailable
- Error.microphoneUnavailable
- Error.networkError
- Error.sessionError
- Error.deprecatedSDKVersion
- Error.unknown
- Error.nfcError
- Error.setupError
- Error.none
