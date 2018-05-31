//
//  ViewController.swift
//  CarevoiceSample
//
//  Created by Gennadiy Ryabkin on 5/18/18.
//  Copyright © 2018 Sense.ly. All rights reserved.
//

import UIKit
import Chat_sensely

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
        
        let s = UIStoryboard (name: "Main", bundle: Bundle(for: AvatarModule.self))
        avatarController = (s.instantiateViewController(withIdentifier: "AvatarModule") as! AvatarModule)
        avatarController?.delegate = self
        avatarController?.assesmentIndex = Int(Configuration.assessmentID)!
        let navigationController:UINavigationController = UINavigationController.init(rootViewController: avatarController!)
        navigationController.isNavigationBarHidden = true
        
        UIApplication.shared.keyWindow?.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    public func invokeCallback(callback:CallbackData) {
        
        print("invokeCallback \(callback.id)")
        
        callback.result = "Data to return"
        
        avatarController?.resultOfInvokeCallback(callback)
    }
}
