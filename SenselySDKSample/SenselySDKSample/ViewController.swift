//
//  ViewController.swift
//  CarevoiceSample
//
//  Created by Gennadiy Ryabkin on 5/18/18.
//  Copyright © 2018 Sense.ly. All rights reserved.
//

import UIKit
import Chat_sensely

enum ConsumerCallbacks: String {
    // `NAS Provider search` assessment
    case providerSearch   = "ProviderSearch"
    
    // `NAS Appointment booking` assessment
    case emisSchedAppts   = "GetSchedEMISAppts"
    case emisCancelAppts  = "CancelEMISAppt"
    case emisAvailAppts   = "GetEMISAvailAppts"
    case emisConfirmAppts = "ConfirmEMISAppt"
    case emisMakeAppts    = "MakeEMISAppt"
    
    // `NAS Appointment booking` assessment
    case getPrescList       = "GetPrescList"
    case confirmPrescRefill = "ConfirmPrescRefill"
    case resultsPrescRefill = "ResultsPrescRefill"
}

class ViewController: UIViewController, SenselyViewControllerDelegate, SenselyCallbacks, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restartButton: UIImageView!
    @IBOutlet weak var restartView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var assessmentsTable: UITableView!
    
    var avatarController:AvatarModule?
    var assessmentsData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        assessmentsTable.delegate = self
        assessmentsTable.dataSource = self
        assessmentsTable.tableFooterView = UIView()
        
        Configuration.callbacks = self
        
        loadConversation()
    }
    
    func loadConversation() {
        
        restartView.isHidden = false
        showLoadingView()
        
        DataManager.sharedInstance.senselyLogin(password:Configuration.clientPassword, username:Configuration.clientUsername ) { (loginResult) in
            switch loginResult {
            case .success( _):
                DataManager.sharedInstance.gettingAssessments { (result) in
                    switch result {
                    case .success( _):
                        print("\(DataManager.sharedInstance.stateMachine.getAssessmentNames())")
                        self.assessmentsData = NSMutableArray.init(array: DataManager.sharedInstance.stateMachine.getAssessmentNames()) as! [String]
                        self.assessmentsTable.reloadData()
                        self.restartView.isHidden = true
                        
                    case .failure( _):
                        break
                    }
                }
            case .failure( _):
                self.hideLoadingView()
                self.showError(message: "Failed to login. Please check your configurations or contact Sensely support.")
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
    func senselyViewController(_ senselyViewController: AvatarModule, didReceiveFinalJSON finalString: String) {
        print("Assessments results: \(finalString)")
    }
    
    func senselyViewController(_ senselyViewController: AvatarModule, didReceiveError error: NSError) {
        let errorType:Configuration.SenselyError
        errorType = Configuration.SenselyError(rawValue: error.code)!
        
        var errorText = "Unrecognized error"
        switch errorType {
        case .InvalidAssesment:
            errorText = "Assesment is invalid"
        case .NetworkError:
            errorText = "There was a network error"
        case .AvatarDoesntLoad:
            errorText = "Avatar doesn't load"
        case .ClosedByUser:
            errorText = "Assesment was closed by the user"
        }
        
        showError(message: errorText)
    }
    
    func showError(message: String) {
        
        let alert = UIAlertController(title: "An Error occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Table view delegate/data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessmentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentRow")
        cell?.textLabel?.text = assessmentsData[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Configuration.assessmentID = String(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        avatarController = AvatarModule(nibName: "AvatarViewController",
                                        bundle: Bundle(for: AvatarModule.self))
        
        guard let avatar = avatarController else {
            fatalError("Avatar not loaded")
        }
        
        avatar.delegate = self
        avatar.assesmentIndex = Int(Configuration.assessmentID)!
        navigationController?.pushViewController(avatar, animated: true)
    }
    
    func openConsumerScreen(callback:CallbackData) {
        
        let s = UIStoryboard (name: "Main", bundle: Bundle.main)
        let cosumerScreen:ConsumerScreen = s.instantiateViewController(withIdentifier: "ConsumerScreen") as! ConsumerScreen
        cosumerScreen.avatarModule = avatarController
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
                avatarController?.resultOfInvokeCallback(callback)
                break
            case .emisConfirmAppts:
                avatarController?.resultOfInvokeCallback(callback)
                break
            case .emisMakeAppts:
                avatarController?.resultOfInvokeCallback(nil)
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
