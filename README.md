# Sensely iOS Conversational SDK

<a href="https://docs.google.com/forms/d/e/1FAIpQLSd0IG28QiYD-_BChDa0OrV3BgAzFJawFvTy6WZFPhmyUb9PCQ/viewform?usp=sf_link"><img src="https://cl.ly/ca1a088639e6/request-access-button.png" alt="Request access" width="157"></a>

The Sensely iOS SDK is designed to allow you to easily incorporate custom avatar technology and conversational content in your iOS app. Start using the SDK today to leverage the power of conversational language interfaces. The avatar supports both voice and text options, allowing you to intelligently communicate with your patient and insurance plan member populations.

## Technical overview

The Sensely SDK can be embedded in an existing app. When calling the SDK, the partner app will get a conversation flow (e.g. mayo symptom checker). Here is an overview of the integration:

* The partner app activates the Sensely UI and begin the conversation experience:
    * The user proceeds through the conversation by interacting with the Sensely UI which generally takes up the full screen inside the app.
    * During the conversation, the sensely conversation engine will direct a user through a flow, described below.
    * At any point, the Sensely SDK can be directed to pause the conversation and return to the partner app using a callback. This is often used to invoke features from the partner app during a conversation such as showing a directory of in-network services or appointment booking flow. 
* Once the conversation has been completed:
    * The results of the conversation are returned to the consuming app in JSON format. These results can also be recorded in Sensely’s backend if desired.
    * The user is transitioned back to the partner app fully.

## Integration with Mayo Clinic symptom assessment tool

Sensely is ready to use with the Mayo Clinic symptom assessment tool in 8 languages (contact us for more languages). The introduction can be reviewed and customized with disclaimers by the partner’s team. The Mayo symptom checker also supports using the symptom checker on behalf of a 3rd party (child, other family member).

In addition to symptom checker interactions, partners are able to build other conversation interactions using either our conversation design tools or ad-hoc using a specification of the conversation definition and building the conversation programmatically. More documentation is available upon request. 

## Technical Quickstart

### Prerequisites
- iOS 12.0+
- Xcode 11+ [xcode]
- [Cocoapods][cocoapods] version 1.0 or later
- Objective-C support (on request)

Follow these directions, with Xcode 8 or higher installed on your mac:
* Clone [the GitHub repo](https://github.com/Sensely/SDK-iOS).
* Open terminal in repo directory and cd `ProjectDirectory`
* Create `Podfile` for your project, see [cocoapods](https://cocoapods.org/)
* `SenselySDK` uses `GoogleSpeech` for voice recognition. Download, untar and move `google` directory and `google.podspec` file to the directory where your `Podfile` located the following [arhive](https://github.com/Sensely/SDK-iOS/blob/master/third-party/google-deps.tar.gz). Add into your Podfile `pod 'googleapis', :path => '.'`
* Add line `pod SenselySDK` 
* Run `pod install` command or `pod update` to get the latest version for sure
* Add in your app's Info.plist `NSMicrophoneUsageDescription` key explaining that you need access to microphone for capturing user's speech by voice recognition engine
* Add header `import SenselySDK` or `#import <SenselySDK/SenselySDK.h>`
* To receive assessment data results subscribe to the delegate `SenselyViewControllerDelegate`:
```
class ViewController: SenselyViewControllerDelegate {
    
     func senselyViewController(_ senselyViewController: BaseSenselyViewController, didReceiveFinalJSON finalString: String) {
        print("Assessments results: \(finalString)")
    }
}
```
* At the appropriate time, you wish the widget to appear, invoke the init method, passing in appropriate parameters to change widgets language, regional server, color scheme and listen to final results event:
```
SenselyWidget.initialize(username: "<username>",
                         password: "<password>",
                      procedureId: "<procedureID>",
                         language: "uk",
                 conversationData: SenselyWidget.conversationData(gender: "M", dob: "1980-10-30", orgId: "<device-uuid>"),
                            theme: "sensely", //
                           region: "", // US server by default
                       navigation: self.navigationController,
                  senselyDelegate: self) { // SenselyViewControllerDelegate
    // Widget is loaded
}
```

## Known issues and limitations

- At the current moment the `SDK` doesn't work with apps which has `SceneDelegate` implemented

- `ENABLED_BITCODE` flag should be set to `NO` for your app

- `SenselyWidget` can be pushed only in navigation controller. So app's root controller where widget is going to be pushed should be embeded in the navigation one.

- To avoid warning <span style="color:red">**ITMS-90381**</span>: Too many symbol files add in your `Podfile` the following lines of code:
```swift
post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
end
```


## Full Documentation and more details

  Contact Sensely for full SDK documentation, including sample code to integrate.
  
  <a href="https://docs.google.com/forms/d/e/1FAIpQLSd0IG28QiYD-_BChDa0OrV3BgAzFJawFvTy6WZFPhmyUb9PCQ/viewform?usp=sf_link"><img src="https://cl.ly/ca1a088639e6/request-access-button.png" alt="Request access" width="157"></a>

## Licenses

The Sensely iOS SDK is released under the Sensely license. See the [LICENSE] file for more details.

[LICENSE]: https://github.com/Sensely/SDK-iOS/blob/master/LICENSE
[cocoapods]: https://cocoapods.org/
[xcode]: https://developer.apple.com/xcode/
[documentation page]: https://sensely.github.io/SDK-iOS/

## Other platforms of the Sensely SDK
* [Web](https://github.com/Sensely/SDK-Web/)
* [Android](https://github.com/Sensely/SDK-Android)
