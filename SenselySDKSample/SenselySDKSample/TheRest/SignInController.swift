//
//  SignInController.swift
//  Sensely
//
//  Created by Egor Afanasenko on 12/8/17.
//

import Chat_sensely
import AVFoundation

open class SignInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var homeTextField: MFTextField!
    @IBOutlet weak var passwordTextField: MFTextField!
    @IBOutlet weak var incorrectView: UIView!
    fileprivate let app = UIApplication.shared.delegate
    fileprivate var rootWindow = UIWindow()
    
    var btnColor: UIColor!
    var dataManager: DataManager = DataManager.sharedInstance
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        homeTextField.delegate = self as UITextFieldDelegate
        homeTextField.returnKeyType = UIReturnKeyType.next
        
        passwordTextField.delegate = self as UITextFieldDelegate
        passwordTextField.returnKeyType = UIReturnKeyType.send
        
        self.incorrectView.isHidden = true
        self.incorrectView.layer.borderWidth = 1.0
        self.incorrectView.layer.borderColor = UIColor.gray.cgColor
        homeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.navigationItem.title = "Sign In".localized
        
        self.descriptionLabel.text = self.descriptionLabel.text.localized
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startMonitoringReachability()
        self.homeTextField.text = nil
        self.passwordTextField.text = nil
        self.continueBtn.isHidden = false
        self.descriptionLabel.isHidden = false
        self.homeTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.view.backgroundColor = UIColor.white
        btnColor = Configuration.blueColor
        
        signInViewsLoadingState()
        self.dataManager.applyTestingProgram { (result) in
            
            switch result {
            case .credentialsChanged, .serverChanged:
                self.login()
                
            case .notApplied:
                
                self.resetSignInScreenViews()
                guard DataManager.sharedInstance.senselyToken != nil else {
                    return
                }
                
                DataManager.sharedInstance.refreshToken { result in
                    switch result {
                    case .success:
                        self.performSegue(withIdentifier: "showAssessmentsList", sender: self)
                    case .failure:
                        break
                    }
                }
            }
        }
     }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopMonitoringReachability()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == homeTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            continueTapped()
        }
        
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func continueTapped(_ sender: Any? = nil) {
        self.view.endEditing(true)
        if homeTextField.text!.count > 1 && passwordTextField.text!.count > 5 {
            
            self.signInViewsLoadingState()
            self.login()
        }
    }
    
    // MARK: - Private
 
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func login() {
        
        self.homeTextField.text = Configuration.clientUsername
        self.passwordTextField.text = Configuration.clientPassword
        
        self.dataManager.senselyLogin(password: Configuration.clientPassword,
                                      username: Configuration.clientUsername,
                                      completion: { result in
                                        
                                        self.resetSignInScreenViews()
                                        switch result {
                                        case .success:
                                            self.performSegue(withIdentifier: "showAssessmentsList", sender: self)
                                            
                                        case .failure:
                                            self.incorrectView.isHidden = false
                                            self.incorrectView.shake()
                                        }
        })
    }
    
    func signInViewsLoadingState() {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.homeTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
        self.continueBtn.loadingIndicator(true)
    }
    
    func resetSignInScreenViews() {
        
        self.continueBtn.loadingIndicator(false)
        self.homeTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.tintColor = self.continueBtn.tintColor
        self.continueBtn.backgroundColor = self.btnColor
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.incorrectView.isHidden = true
        Configuration.clientUsername = homeTextField.text!
        Configuration.clientPassword = passwordTextField.text!
        if homeTextField.text!.count > 1 && passwordTextField.text!.count > 5 {
            continueBtn.backgroundColor = btnColor
        } else {
            continueBtn.backgroundColor = UIColor.gray
        }
    }
}
