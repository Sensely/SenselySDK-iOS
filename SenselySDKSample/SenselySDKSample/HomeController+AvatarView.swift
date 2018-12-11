//
//  HomeController+AvatarView.swift
//  SenselySDKTest
//
//  Created by Gennadiy Ryabkin on 9/27/18.
//  Copyright © 2018 Sensely. All rights reserved.
//

import Foundation
import Chat_sensely

extension HomeController: SenselyAvatarViewDelegate {
    
    // MARK: - SenselyAvatarViewDelegate
    
    func avatarView(_ view: SenselyAvatarView, didFinishLoading result: SenselyAvatarView.Result) {
        switch result {
        case .success:
            hideLoadingScreen()
            // senselyAvatarView.model.isVocal = true
            // senselyAvatarView.say(textToSpeech: "Hello my name is Molly and I like you", andPrefetch: [])
            
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
