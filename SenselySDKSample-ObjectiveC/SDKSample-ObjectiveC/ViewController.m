//
//  ViewController.m
//  SDKSampleObjective-C
//
//  Created by Gennadiy Ryabkin on 2/13/19.
//  Copyright © 2019 Sense.ly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <SenselyViewControllerDelegate> {
    UIColor *senselyColor;
}

    @property (nonatomic) DataManager* dataManager;
@property (strong, nonatomic) IBOutlet TagButton *startAvatarBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *btnLoading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    senselyColor = [[UIColor alloc] initWithRed:2./256. green:133./256. blue:201./256. alpha:1];
    
    self.dataManager = [DataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self enableButton];
}

- (IBAction)startAvatar:(TagButton *)sender {
    
    [self disableButton];
    // Authorize SDK
    // Warning: Required step
    [self.dataManager senselyLoginWithPassword:@"" username:@"" completion:^{
        
        // Get assessment' procedures assigned on еру user with conversation' metadata (names/icons)
        // Warning: Required step
        [self.dataManager gettingAssessmentsWithCompletion:^{
            
            // Retrieve procedure id
            // number of items can be get from this data:
            // [self.dataManager.stateMachine getAssessmentNames];
            // [self.dataManager.stateMachine getAssessmentIcons];
            NSString* procedureID = [self.dataManager.stateMachine getProcedureIdAtIndex:0];
            
            // Override `userInfo` settings to skip states with questions answers to which system already knows
            NSString* userInfo = @"{\"userInfo\":{\"gender\":\"M\", \"dob\":\"1980-10-30\", \"first_name\":\"Jenny\"}}";
            [self.dataManager overrideSettingsWithUserInfo:userInfo];
            
            // Initialize chat
            ChatViewController* senselyChat = [[ChatViewController alloc] initWithNibName:ChatViewController.nibName
                                                                                   bundle:[NSBundle bundleForClass:[ChatViewController class]]];
            
            // Set delegate and implement callbacks for getting final results and handle other events in the chat with avatar
            senselyChat.delegate = self;
            
            // Set procedure-id and invoke assessment' start
            [senselyChat startWithProcedureID:procedureID
                       inNavigationController:self.navigationController];
            
        } failure:^{
            
            NSLog(@"Can't get assessments");
            [self enableButton];
        }];
        
    } failure:^{
        NSLog(@"Wrong credentials");
        [self enableButton];
    }];
}

// Final results
- (void)senselyViewController:(BaseSenselyViewController * _Nonnull)senselyViewController
          didReceiveFinalJSON:(NSString * _Nonnull)finalString {
    
    NSLog(@"Final json %@", finalString);
}

- (void)didReceiveDiagnosisData:(BaseSenselyViewController * _Nonnull)senselyViewController
                        urgency:(NSString * _Nonnull)urgency
                        assetID:(NSString * _Nonnull)assetID {
    
    NSLog(@"Mayo recomendation %@, assetID %@", urgency, assetID);
}
    
- (void)previosStateButtonClicked:(BaseSenselyViewController * _Nonnull)senselyViewController {
    
    // empty stub
}
    
- (void)senselyViewController:(UIViewController * _Nonnull)senselyViewController didReceiveError:(enum SenselyError)error {
    
    // empty stub
}
    
- (void)voiceRecognitionDidEnd:(BaseSenselyViewController * _Nonnull)senselyViewController {
    
    // empty stub
}
    
- (void)voiceRecognitionWillStart:(BaseSenselyViewController * _Nonnull)senselyViewController {
    
    // empty stub
}

- (void)enableButton {
    self.startAvatarBtn.backgroundColor = senselyColor;
    [self.btnLoading stopAnimating];
}

- (void)disableButton {
    self.startAvatarBtn.backgroundColor = UIColor.grayColor;
    [self.btnLoading startAnimating];
}

@end
