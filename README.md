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
- iOS 13.0+
- Xcode 14.3+ [xcode]

### To run samples:
* Clone [the GitHub repo](https://github.com/Sensely/SDK-iOS).
* `open ObjSample.xcodeproj` or `open SwiftSample.xcodeproj`


### To integrate into your project:
* To add with SPM follow [this guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) and use link to [the GitHub repo](https://github.com/Sensely/SDK-iOS).
* In `Build Settings -> Link Binary with libraries` section add `SenselySDK`


### To start working with SenselySDK:

Follow these directions, with Xcode 14.3+ installed on your mac:

* Add in your app's Info.plist `NSMicrophoneUsageDescription` key explaining that you need access to microphone for capturing user's speech by voice recognition engine
* Add header `import SenselySDK` or `#import <SenselySDK/SenselySDK.h>` for Obj-C
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
                         language: "uk", // Optional: default 'en'
                         conversationData: SenselyWidget.conversationData(gender: "M", dob: "1980-10-30", orgId: "<device-uuid>", custom: ["mykey": "myvalue"]),
                         theme: "sensely", // Optional: default 'sensely'
                         defaultAudio: "on",  // "on", "off", "ask". Default set to "on" if skipped
                         controller: self.navigationController,
                         delegate: self,
                         completion: { // SenselyViewControllerDelegate
                
                // Widget is loaded
         })
```

## Known issues and limitations

### Versions prior 3.14.2 are distributed using cocoapods. You need cocoapods 1.0+

* Create `Podfile` for your project, see [cocoapods](https://cocoapods.org/)
* Add line `pod SenselySDK` 
* Run `pod install` command or `pod update` to get the latest version for sure
* Follow directions in `To start working with SenselySDK` section
 

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
