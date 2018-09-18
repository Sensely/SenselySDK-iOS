//
//  ConsumerScreen.swift
//  Sensely
//
//  Created by Gennadiy Ryabkin on 5/22/18.
//  Copyright © 2018 Sensely. All rights reserved.
//

import UIKit
import Chat_sensely

class ConsumerScreen: UIViewController {
    
    var avatarModule: BaseSenselyViewController?
    var senselyCallback: CallbackData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getBackToSensely(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        guard let callback = senselyCallback else {
            print("Cann't continue sensely without CallbackData")
            return
        }
        avatarModule?.resultOfInvokeCallback(callback)
    }
}
