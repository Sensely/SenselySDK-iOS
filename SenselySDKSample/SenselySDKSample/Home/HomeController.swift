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

class HomeController: UIViewController, SenselyViewControllerDelegate, SenselyCallbacks {
    
    @IBOutlet weak var restartButton: UIImageView!
    @IBOutlet weak var restartView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var avatarController:ChatViewController?
    var audioPlayer: AVAudioPlayer?
    
    static let footerHeight: CGFloat = 70.0
    var arrayWithImages = [String]()
    var arrayWithNames = [String]()
    fileprivate var dataSourceList = NSMutableArray()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Configuration.callbacks = self
        /*
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParentViewController {
            DataManager.sharedInstance.logOut(completion: {})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        registerAllCellAndFootersForCV(collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.backgroundColor  = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = false
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: view.frame.width, height: HomeController.footerHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width - 0, height: 60)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = layout
            self.loadConversation()
        }
    }
    
    fileprivate func registerAllCellAndFootersForCV(_ collectionView: UICollectionView) {
        let cellNib = UINib(nibName: "HomeCell",
                            bundle: Bundle.main)
        let footerNib = UINib(nibName: "HomeFooter",
                              bundle: Bundle.main)
        
        collectionView.register(cellNib,
                                forCellWithReuseIdentifier: "HomeCell")
        collectionView.register(footerNib,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                withReuseIdentifier: "HomeFooter")
    }
    
    /// MARK: Load conversation
    
    func loadConversation() {
        
        restartView.isHidden = false
        showLoadingView()
        
        DataManager.sharedInstance.gettingAssessments { (result) in
            switch result {
            case .success( _):
                print("\(DataManager.sharedInstance.stateMachine.getAssessmentNames())")
                self.restartView.isHidden = true
                
                self.collectionView.isHidden = false
                self.arrayWithImages = DataManager.sharedInstance.stateMachine.getAssessmentIcons()
                self.arrayWithNames = DataManager.sharedInstance.stateMachine.getAssessmentNames()
                DataManager.sharedInstance.areAssessmentsReady = true
                self.collectionView.reloadData()
                
            case .failure( _):
                DataManager.sharedInstance.logOut(completion: {
                    self.dismiss(animated: true, completion: {})
                })
                break
            }
        }
    }
    
    @IBAction func onRestart(_ sender: Any) {
        loadConversation()
    }
    
    func hideLoadingView() {
        restartButton.isHidden = false
        loading.stopAnimating()
        loading.isHidden = true
    }
    
    func showLoadingView() {
        restartButton.isHidden = true
        loading.startAnimating()
        loading.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Sensely delegate
    func senselyViewController(_ senselyViewController: BaseSenselyViewController, didReceiveFinalJSON finalString: String) {
        print("Assessments results: \(finalString)")
    }
    
    func senselyViewController(_ senselyViewController: BaseSenselyViewController, didReceiveError error: NSError) {
        let errorType:Configuration.SenselyError
        errorType = Configuration.SenselyError(rawValue: error.code)!
        
        var errorText = "Unrecognized error"
        switch errorType {
        case .invalidAssesment:
            errorText = "Assesment is invalid"
        case .networkError:
            errorText = "There was a network error"
        case .avatarDoesntLoad:
            errorText = "Avatar doesn't load"
        case .closedByUser:
            errorText = "Assesment was closed by the user"
        }
        
        showError(message: errorText)
    }
    
    func previosStateButtonClicked(_ senselyViewController: BaseSenselyViewController) {
        //
    }
    
    func voiceRecognitionWillStart(_ senselyViewController: BaseSenselyViewController) {
        //self.audioPlayer?.pause()
    }
    
    func voiceRecognitionDidEnd(_ senselyViewController: BaseSenselyViewController) {
        //self.audioPlayer?.play()
    }
    
    func showError(message: String) {
        
        let alert = UIAlertController(title: "An Error occured".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK".localized, comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occurred.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openConsumerScreen(callback: CallbackData) {
        
        let s = UIStoryboard (name: "Main", bundle: Bundle.main)
        let cosumerScreen:ConsumerScreen = s.instantiateViewController(withIdentifier: "ConsumerScreen") as! ConsumerScreen
        cosumerScreen.avatarModule = self.avatarController
        cosumerScreen.senselyCallback = callback
        self.navigationController?.pushViewController(cosumerScreen, animated: true)
    }
    
    public func invokeCallback(callback:CallbackData) {
        
        print("invokeCallback \(callback.id)")
        
        callback.result = "Data to return"
        
        if let callbackName = ConsumerCallbacks(rawValue: callback.id) {
            switch callbackName {
            case .providerSearch:
                openConsumerScreen(callback: callback)
                break
            case .emisSchedAppts, .emisCancelAppts, .emisAvailAppts:
                callback.result = emisAppointments()
                self.avatarController?.resultOfInvokeCallback(callback)
                break
            case .emisConfirmAppts:
                self.avatarController?.resultOfInvokeCallback(callback)
                break
            case .emisMakeAppts:
                self.avatarController?.resultOfInvokeCallback(nil)
                break;
            case .getPrescList, .confirmPrescRefill:
                break
            default:
                break;
            }
        }
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
}
