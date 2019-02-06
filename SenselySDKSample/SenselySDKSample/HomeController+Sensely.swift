//
//  HomeController+AvatarView.swift
//  SenselySDKTest
//
//  Created by Gennadiy Ryabkin on 9/27/18.
//  Copyright © 2018 Sensely. All rights reserved.
//

import Foundation
import Chat_sensely

extension HomeController: SenselyViewControllerDelegate, SenselyCallbacks {
    
    /// MARK: Download conversations, initializing
    
    func loadConversation() {
        
        DataManager.sharedInstance.gettingAssessments { (result) in
            switch result {
            case .success:
                self.loadingIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.arrayWithImages = DataManager.sharedInstance.stateMachine.getAssessmentIcons()
                self.arrayWithNames = DataManager.sharedInstance.stateMachine.getAssessmentNames()
                self.collectionView.reloadData()
            case .failure(let error):
                
                let message = "An error occurred while retrieving data from the server, please try again".localized
                print(error.dictionaryBody.description)
                self.showRetryCancelModalAlert(title: "Server error".localized,
                                               message: message,
                                               retryBlock: {
                                                self.loadConversation()
                }, cancelBlock: {
                    self.abortLoading()
                })
            }
        }
    }
    
    // MARK: Starting specific conversation
    
    public func startConversation(atIndex indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            Configuration.assessmentID = String(indexPath.row)
            
            var chatOptions = ChatOptions()
            chatOptions.procedureID = DataManager.sharedInstance.stateMachine.getProcedureId(at: Int32(indexPath.item))
            
            let viewController = ChatViewController(nibName: "ChatViewController",
                                                    bundle: Bundle(for: ChatViewController.self))
            viewController.startChat(withOptions: chatOptions, inNavigationController: self.navigationController)
            viewController.delegate = self
            
            self.collectionView.deselectItem(at: indexPath, animated: true)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    // MARK: SenselyCallbacks
    
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
    
    //MARK - Invoke callback state
    
    func openConsumerScreen(callback: CallbackData) {
        
        let s = UIStoryboard (name: "Main", bundle: Bundle.main)
        let cosumerScreen:ConsumerScreen = s.instantiateViewController(withIdentifier: "ConsumerScreen") as! ConsumerScreen
        cosumerScreen.avatarModule = self.avatarController
        cosumerScreen.senselyCallback = callback
        self.navigationController?.pushViewController(cosumerScreen, animated: true)
    }
    
    // MARK: SenselyViewControllerDelegate delegate
    
    func senselyViewController(_ senselyViewController: BaseSenselyViewController, didReceiveFinalJSON finalString: String) {
        print("Assessments results: \(finalString)")
    }
    
    func didReceive(_ senselyViewController: BaseSenselyViewController, diagnosisData data: DiagnosisData) {
        print("Diagnosis data: urgency -> \(data.urgency), asset_id -> \(data.assetID)")
    }
    
    func senselyViewController(_ senselyViewController: UIViewController, didReceiveError error: SenselyError) {
        
        switch error {
        case .initializationFailure, .conversationFailure:
            let alertController = UIAlertController(title: "The assessment wasn't initialized".localized,
                                                    message: "Data is corrupted or not full".localized,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(dismissWithHandler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
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
}
