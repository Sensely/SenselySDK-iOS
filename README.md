# SDK-iOS

# Sensely iOS SDK (beta)

This **Swift library** allows you to integrate Sensely into your iOS app.

## Beta

Please keep in mind that this SDK is in a Pre-1.0 release state and is still actively being developed. There may be breaking changes introduced as we work towards stability. Please check the Changelog before updating to a new version.

## Requirements

* iOS 8.0+
* Xcode 8.0+
* Swift 3.0 or Objective-C

## Getting Started

###Manually Chat_sensely.framework 

####Step 1: Drag the **Chat_sensely.framework** inside your sample project under the main sample project file.

![alt text](https://s20.postimg.org/q0jw0to5p/Chat_sensely.framework.png)

####Step 2: Choose those items:

![alt text](https://s20.postimg.org/47d4e99cd/Screen_Shot_2017-07-26_at_10.21.03.png)
####Step 3: Embed the framework:

Select your *YourProject.xcodeproj* file. Under "General", add the **Chat_sensely.framework** as an embedded binary

![alt text](https://s20.postimg.org/dw4mjub9p/Embed_the_framework.png)

####Step 4: SDK Configuration

SDK provides a static Configuration class to further customize your settings. Inside of *application:didFinishLaunchingWithOptions:* in your AppDelegate is a good place to do this:

```
// Don’t forget to import SenselySDK
import Chat_sensely.Swift
// ...
// Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     Configuration.setClientID(clientID: "ClientID")
     Configuration.setSecretClientID(clientSecretID: "ClientSecretID")
     Configuration.setSenselyClientUsername(clientUsername: "ClientUsername")
     Configuration.setSenselyClientPassword(clientPassword: "ClientPassword")
     Configuration.setSenselyAssesmentID(senselyAssesmentID: "SenselyAssesmentID")
     Configuration.setSenselyAvatarName(senselyAvatarName: "SenselyAvatarName")
     return true
    }
```

```
// Don’t forget to import SenselySDK
#import <Chat_sensely/Chat_sensely-Swift.h>
// ...
// Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 	 [SenselySDKConfiguration setClientIDWithClientID:@"ClientID"];
    [SenselySDKConfiguration setSecretClientIDWithClientSecretID:@"ClientSecretID"];
    [SenselySDKConfiguration setSenselyClientUsername:@"ClientUsername"];
    [SenselySDKConfiguration setSenselyClientPassword:@"ClientPassword"];
    [SenselySDKConfiguration setSenselyAssesmentIDWithSenselyAssesmentID:@"SenselyAssesmentID"];
    [SenselySDKConfiguration setSenselyAvatarNameWithSenselyAvatarName:@"SenselyAvatarName"];
    return YES;
}
```

**ClientID**, **ClientSecretID** - your credentials provided by Sensely

**ClientUsername**, **ClientPassword** - your credentials provided by Sensely

**SenselyAssesmentID** - the id of the assesment that is used for the Sensely View Controller (provided by Sensely)



**senselyAvatarName** - the name of the avatar that is used for the Sensely View Controller. For now it can be: **Olivia** or **Molly**

***IMPORTANT*** 

Avatar will invoke automatically according to **senselyAvatarName** (default is **Olivia**) 


####Step 5: Bitcode Configuration
 
Make sure Enable Bitcode is No

![alt text](https://s20.postimg.org/sp5825bwt/Screen_Shot_2017-07-26_at_10.36.50.png)
![alt text](https://s26.postimg.org/qt32c6pex/Screen_Shot_2017-09-11_at_12.45.11.png)

####Configuring iOS 9.0+

If you are compiling on iOS SDK 9.0+, you will need to modify your application’s plist to handle Apple’s [new security changes](https://developer.apple.com/videos/play/wwdc2015/703/) to the canOpenURL function. Locate the Info.plist file for your application. Usually found in the **Supporting Files** folder. Right-click this file and select **Open As > Source Code**

```
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
	<key>NSMicrophoneUsageDescription</key>
	<string>Need it </string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
	</array>
```

![alt text](https://s1.postimg.org/76oh00ebpb/Screen_Shot_2017-10-06_at_11.18.50.png)

##Example Usage

###Quick Integration

Don’t forget to import *SenselySDK* by specifiing the import - Chat_sensely.Swift (Swift) and Chat_sensely-Swift.h (Objective-C)

The *SenselyButton* is a simple way to open *SenselyViewController* from your application, you only need to create a *SenselyButton* object (from the storybord or your code) and set the view controller which is used as delegate for *SenselyViewController*

Please don’t forget to confirm *SenselyViewControllerDelegate* for the error handling and for handling the final result from the Sensely Controller


```
// Swift
import Chat_sensely.Swift

// Don’t forget to confirm SenselyViewControllerDelegate

class YourViewController: UIViewController, SenselyViewControllerDelegate {

@IBOutlet weak var senselyButton: SenselyButton!

override func viewDidLoad() {
        super.viewDidLoad()
        senselyButton.presentingController = self
}

```

```
// Objective-C
#import <Chat_sensely/Chat_sensely-Swift.h>
// Don’t forget to confirm SenselyViewControllerDelegate

@interface ViewController ()<SenselyViewControllerDelegate>
@property (weak, nonatomic) IBOutlet SenselyButton *senselyButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.senselyButton.presentingController = self;
}

```

That’s it! When a user taps the button, a **SenselyViewController** will be modally presented, containing a **AvatarView** prefilled with the *avatar* provided from the **senselyAvatarName** object and with the *assesment* provided from the **SenselyAssesmentID** object. 

You should set a **SenselyViewControllerDelegate** to:

* handle the final result of the assesment 
* obtain the results of the avatar interaction 
* handle all of error from the Sensely SDK

**SenselyViewControllerDelegate** has two callback, the final result handler and the error handler


```
//MARK - SenselyViewControllerDelegate
  
func senselyViewController(senselyViewController: SSHomeScreenModule, didReceiveFinalJSON finalDict: NSDictionary){
//do what you want with the finalDict
    print(finalDict)
}
    
func senselyViewController(senselyViewController: SSHomeScreenModule, didReceiveError error: NSError{
    print(error)
}  
```

```
#pragma mark - SenselyViewControllerDelegate

- (void)senselyViewControllerWithSenselyViewController:(SSHomeScreenModule * _Nonnull)senselyViewController didReceiveFinalJSON:(NSDictionary * _Nonnull)finalDict{
//do what you want with the finalDict
   NSLog(@"%@", finalDict);
}

- (void)senselyViewControllerWithSenselyViewController:(SSHomeScreenModule * _Nonnull)senselyViewController didReceiveError:(NSError * _Nonnull)error{
   NSLog(@"%@", error);
}
```

##Example Apps

Example apps can be found in the *examples* folder.

For Objective-C projects, set the **Embedded Content Contains Swift Code** flag in your project to **Yes** (found under **Build Options** in the **Build Settings** tab).

Now you can build the project.

Don’t forget to set *ClientID*, *ClientSecretID*, and *SenselyAssesmentID*.

##Getting help

Sensely developers actively monitor the Sensely Tag on *StackOverflow*. If you need help installing or using the library, you can ask a question there. Make sure to tag your question with Sensely-api and ios!

For full documentation about our API, visit our Developer Site.

##License

The Sensely iOS SDK is released under the Sensely license. See the LICENSE file for more details.
