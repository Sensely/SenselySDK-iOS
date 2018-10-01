//
//  HomeController+AvatarView.swift
//  SenselySDKTest
//
//  Created by Gennadiy Ryabkin on 9/27/18.
//  Copyright © 2018 Sensely. All rights reserved.
//

import Foundation
import Chat_sensely.Swift

extension HomeController: SenselyAvatarViewDelegate {
    
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
