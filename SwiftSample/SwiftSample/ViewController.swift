//
//  ViewController.swift
//  SwiftSample
//
//  Created by Gennadiy Ryabkin on 11/10/20.
//

import Foundation
import UIKit
import SenselySDK

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var procedureID: UITextField!
    
    @IBOutlet weak var language: UITextField!
    
    @IBOutlet weak var theme: UITextField!
    
    @IBOutlet weak var region: UITextField!
    
    @IBOutlet weak var start: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func startAssessment(_ sender: Any) {
        
        if username.text == nil || username.text!.isEmpty {
            self.alertUser(msg: "Username required parameter")
            return
        }
        
        if password.text == nil || password.text!.isEmpty {
            self.alertUser(msg: "Password required parameter")
            return
        }
        
        if procedureID.text == nil || procedureID.text!.isEmpty {
            self.alertUser(msg: "ProcedureID required parameter")
            return
        }
        
        guard let nav = self.navigationController else {
            self.alertUser(msg: "SenselyWidget can be pushed only in navigation controller")
            return
        }
        
        // Information about user used to skip some questions with already known answers
        let cData = ConversationData(userInfo: UserInfo(gender: "M",
                                                        dob: "1980-10-30",
                                                        orgId: NSUUID().uuidString))
        self.controls(enable: false)
        
        SenselyWidget.initialize(username: username.text!,
                                 password: password.text!,
                                 procedureId: procedureID.text!,
                                 language: language.text ?? "", // Optional: default 'en'
                                 conversationData: cData,
                                 theme: theme.text ?? "", // Optional: default 'sensely'
                                 region: region.text ?? "", // Optional: default 'us'
                                 controller: nav,
                                 delegate: self,
                                 completion: {
                
                print("SenselyWidget initization success or failure, catch errors with SenselyDelegate")
                self.controls(enable: true)
         })
    }
    
    private func alertUser(msg: String) {
        
        let alert = UIAlertController(title: "Wrong parameters", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.controls(enable: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func controls(enable isEnabled: Bool) {
        username.isEnabled = isEnabled
        password.isEnabled = isEnabled
        procedureID.isEnabled = isEnabled
        language.isEnabled = isEnabled
        theme.isEnabled = isEnabled
        region.isEnabled = isEnabled
        start.isEnabled = isEnabled
    }
}

extension ViewController: SenselyViewControllerDelegate {
    
    func senselyViewController(_ senselyViewController: BaseSenselyViewController, didReceiveFinalJSON finalString: String) {
        
        guard let data = finalString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        
        print("Simplified results version `conversationOutput`: \(String(describing: json["conversationOutput"]))")
    }
    
    func senselyViewController(_ senselyViewController: UIViewController, didReceiveError error: SenselyError) {
        
        self.controls(enable: true)
        
        switch error {
        case .conversationFailure:
            self.alertUser(msg: "Broken conversation data")
        case .initializationFailure:
            self.alertUser(msg: "Typically wrong credentials, wrong server or server availability")
        default:
            print("Dummy")
        }
    }
    
    func voiceRecognitionWillStart(_ senselyViewController: BaseSenselyViewController) {
        //
    }
    
    func voiceRecognitionDidEnd(_ senselyViewController: BaseSenselyViewController) {
        //
    }
    
    func previosStateButtonClicked(_ senselyViewController: BaseSenselyViewController) {
        //
    }
    
    func didReceiveDiagnosisData(_ senselyViewController: BaseSenselyViewController, urgency: String, assetID: String) {
        //
    }
    
    func updateConversationsList() {
        //
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
