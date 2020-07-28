# Sensely iOS Conversational SDK

<a href="mailto:info@sensely.com"><img src="https://cl.ly/ca1a088639e6/request-access-button.png" alt="Request access" width="157"></a>

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
- iOS 11.0+
- Xcode 10.2+ [xcode]
- [Cocoapods][cocoapods] version 1.0 or later
- Framework is written in Swift 5.0
- Objective-C support (on request)

Follow these directions, with Xcode 8 or higher installed on your mac:
* Clone [the GitHub repo](https://github.com/Sensely/SDK-iOS).
* Open terminal in repo directory and cd `ProjectDirectory`
* For `Objective-C` version set flag `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES`
* `SenselySDK` uses `GoogleSpeech` for voice recognition. Download, untar and move `google` directory and `google.podspec` file to the directory where your `Podfile` located the following [arhive](https://github.com/Sensely/SDK-iOS/blob/master/third-party/google-deps.tar.gz). Add into your Podfile `pod 'googleapis', :path => '.'`
* If you are using Swift version and have problems with Google's speech imports, run script `./FIX_GOOGLE_SPEECH_IMPORTS.sh` located in `SenselySDKSample/` folder
* Run pod install to download and build CocoaPods dependencies.
    * To install CocoaPods, see [here](https://cocoapods.org/#install).
* Open the Xcode project by running open SenselySDKSample.xcworkspace from the terminal
* Specify `Privacy - Microphone Usage Description` - `So that avatar can hear you`
* Build and run the project on iOS simulator or real device
* When the app loads, provide your username and password to see available conversations - request a demo license from Sensely to get access (see below).


- To avoid warning ITMS-90381: Too many symbol files add in your `Podfile` the following lines of code:
```swift
post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['VALID_ARCHS'] = 'arm64'
    end
end
```


## Full Documentation and more details

  Contact Sensely for full SDK documentation, including sample code to integrate.
  <a href="mailto:info@sensely.com"><img src="https://cl.ly/ca1a088639e6/request-access-button.png" alt="Request access" width="157"></a>

## Licenses

The Sensely iOS SDK is released under the Sensely license. See the [LICENSE] file for more details.

[LICENSE]: https://github.com/Sensely/SDK-iOS/blob/master/LICENSE
[cocoapods]: https://cocoapods.org/
[xcode]: https://developer.apple.com/xcode/
[documentation page]: https://sensely.github.io/SDK-iOS/

## Other platforms of the Sensely SDK
* [Web](https://github.com/Sensely/SDK-Web/)
* [Android](https://github.com/Sensely/SDK-Android)
