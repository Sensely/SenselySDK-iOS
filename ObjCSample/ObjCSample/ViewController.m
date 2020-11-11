//
//  ViewController.m
//  ObjCSample
//
//  Created by Gennadiy Ryabkin on 11/10/20.
//

#import "ViewController.h"
#import <SenselySDK/SenselySDK.h>

@interface ViewController () <SenselyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *procedureID;

@property (weak, nonatomic) IBOutlet UITextField *language;

@property (weak, nonatomic) IBOutlet UITextField *theme;

@property (weak, nonatomic) IBOutlet UITextField *region;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideKeyboardWhenTappedAround];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self controls: YES];
}

- (IBAction)startAssessment:(id)sender {
    
    if ([self username].text == nil || [[self username].text length] == 0) {
        [self alertUser:@"Username required parameter"];
        return;
    }
    
    if ([self password].text == nil || [[self password].text length] == 0) {
        [self alertUser:@"Password required parameter"];
        return;
    }
    
    if ([self procedureID].text == nil || [[self procedureID].text length] == 0) {
        [self alertUser:@"ProcedureID required parameter"];
        return;
    }
    
    if (self.navigationController == nil) {
        [self alertUser:@"SenselyWidget can be pushed only in UINavigation controller. So app's root controller where widget is going to be pushed should be embeded in the navigation one."];
        return;
    }
    
    NSString* uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    ConversationData* userData = [SenselyWidget conversationDataWithGender:@"M"
                                                                       dob:@"1980-10-30"
                                                                     orgId:uuid];
    
    [self controls: NO];
    [SenselyWidget initializeWithUsername:[self username].text
                                 password:[self password].text
                              procedureId:[self procedureID].text
                                 language:[self language].text
                         conversationData:userData
                                    theme:[self theme].text
                                   region:[self region].text
                               navigation:self.navigationController
                          senselyDelegate:self
                               completion:^{
        
        NSLog(@"SenselyWidget initization success or failure, catch errors with SenselyDelegate");
    }];
}

- (void)alertUser:(NSString*) msg {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wrong parameters"
                                   message:msg
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self controls: YES];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) controls:(BOOL) isEnabled {
    
    [self username].enabled = isEnabled;
    [self password].enabled = isEnabled;
    [self procedureID].enabled = isEnabled;
    [self language].enabled = isEnabled;
    [self theme].enabled = isEnabled;
    [self region].enabled = isEnabled;
    [self startBtn].enabled = isEnabled;
}

- (void) hideKeyboardWhenTappedAround {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard {
    [self.view endEditing: YES];
}

- (void)senselyViewController:(BaseSenselyViewController * _Nonnull)senselyViewController didReceiveFinalJSON:(NSString * _Nonnull)finalString {
    
    if (finalString && [finalString length] > 0) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[finalString dataUsingEncoding: NSUTF8StringEncoding]
                                                             options:kNilOptions error:&error];
        if (error == nil) {
            NSLog(@"%@", json[@"conversationOutput"]); // final results in simplified format
        }
    }
}

- (void)senselyViewController:(UIViewController * _Nonnull)senselyViewController
              didReceiveError:(enum SenselyError)error {
    
    switch (error) {
        case SenselyErrorConversationFailure:
            [self alertUser:@"Broken conversation data"];
            break;
        case SenselyErrorInitializationFailure:
            [self alertUser:@"Typically wrong credentials, wrong server or server availability"];
            break;
        default:
            NSLog(@"Dummy");
            break;
    }
}

- (void)previosStateButtonClicked:(BaseSenselyViewController * _Nonnull)senselyViewController {
    //
}

- (void)didReceiveDiagnosisData:(BaseSenselyViewController * _Nonnull)senselyViewController urgency:(NSString * _Nonnull)urgency assetID:(NSString * _Nonnull)assetID {
    //
}

- (void)updateConversationsList {
    //
}

- (void)voiceRecognitionDidEnd:(BaseSenselyViewController * _Nonnull)senselyViewController {
    //
}

- (void)voiceRecognitionWillStart:(BaseSenselyViewController * _Nonnull)senselyViewController {
    //
}

@end
