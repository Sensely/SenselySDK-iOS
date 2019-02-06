/***
 ViewController.swift
 Sensely
 
 After successfull authorization with Sensely conversation platform
 the next step is to fetch conversations from the backend server. This logic is
 described in loadConversation() function.
 
 Conversational logic and data is stored in an instatnce of StateMachine:
 DataManager.sharedInstance.stateMachine
 
 After picking an assessment name you have two options to initialize a conversation:
 1. Using
          AvatarController (half screen will be occupied by avatar and another half by options to choose)
       or ChatController (avatar is in small circle can be muted, options to answer and questions are represented in a chat manner)
 2. You need to set `assessmentIndex` property to apply settings specific to a picked conversation which are set in *Sensely Dashboard*:
    avatar voice, avatar look, voice input language
    These properties can be overriden by using class `Configuration`
    New values have to be set after setting `assessmentIndex`
 3. Translation language of dialogs and widgets is controlled by default by language set in mobile settings
    Conversation translation is handled in *Sensely Dashboard* and controlled by conversation designer
 
 Created by Gennadiy Ryabkin on 5/18/18.
 Copyright © 2018 Sense.ly. All rights reserved.
 */

import UIKit
import AVFoundation
import Chat_sensely

enum ConsumerCallbacks: String {
    // `Provider search` assessment
    case providerSearch   = "ProviderSearch"
    
    // `Appointment booking` assessment
    case emisSchedAppts   = "GetSchedEMISAppts"
    case emisCancelAppts  = "CancelEMISAppt"
    case emisAvailAppts   = "GetEMISAvailAppts"
    case emisConfirmAppts = "ConfirmEMISAppt"
    case emisMakeAppts    = "MakeEMISAppt"
    
    // `Appointment booking` assessment
    case getPrescList       = "GetPrescList"
    case confirmPrescRefill = "ConfirmPrescRefill"
    case resultsPrescRefill = "ResultsPrescRefill"
}

class HomeController: UIViewController, SenselyAvatarViewDelegate {
    
    var avatarController:ChatViewController?
    var assessmentsData: [String] = []
    var audioPlayer: AVAudioPlayer?
    
    fileprivate var opaqueView = UIView()
    static let footerHeight: CGFloat = 70.0
    var arrayWithImages = [String]()
    var arrayWithNames = [String]()
    fileprivate var dataSourceList = NSMutableArray()
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var senselyAvatarView: SenselyAvatarView!
    var loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    public var customTagCellNib = UINib(nibName: "CustomTagButton",
                                  bundle: Bundle(for: HomeController.self))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Configuration.callbacks = self
        /* There is an options to play custom music on the background
        let path = Bundle.main.path(forResource: "n99.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
        }*/
        
        title = "Home".localized
        loadConversation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParent {
            DataManager.sharedInstance.logOut(completion: {})
        }
        senselyAvatarView.pauseAvatar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        registerAllCellAndFootersForCV(collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.senselyAvatarView.addBehavior()
        self.senselyAvatarView.setScale(setScale: 0.5)
        self.senselyAvatarView.avatarPercentTop = -9
        self.senselyAvatarView.setCanvasScale(scaleX: 1.25, y: 1.25)
        self.senselyAvatarView.senselyAvatarViewDelegate = self
        self.senselyAvatarView.resumeAvatar()
        self.installCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Test data
    
    func emisAppointments() -> String {
        
        if let path = Bundle.main.path(forResource: "appointments_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return String(data: data, encoding: .utf8)!
                
            } catch {
                // handle error
            }
        }
        return ""
    }
    
    // MARK: - Helpers
    
    func abortLoading() {
        DataManager.sharedInstance.logOut(completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func hideLoadingScreen() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.opaqueView.alpha = 0
                        self.installCollectionView()
        }, completion: { _ in
            self.opaqueView.isHidden = true
        })
    }
    
    func showError(message: String) {
        
        let alert = UIAlertController(title: "An Error occured".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK".localized, comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occurred.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SenselyAvatarViewDelegate
    
    func avatarView(_ view: SenselyAvatarView, didFinishLoading result: SenselyAvatarView.Result) {
        switch result {
        case .success:
            hideLoadingScreen()
            
        case .failure:
            let message = "The avatar couldn't load. Try logging in again. Otherwise, contact support.".localized
            let controller = UIAlertController(title: "Avatar Problem".localized,
                                               message: message,
                                               preferredStyle: .alert)
            
            controller.addAction(UIAlertAction.init(dismissWithHandler: { [weak self] _ in
                self?.abortLoading()
            }))
            present(controller, animated: true, completion: nil)
        }
    }
    
    func avatarView(_ view: SenselyAvatarView, didSayTextVocally: Bool) {
        // do nothing
    }
}
