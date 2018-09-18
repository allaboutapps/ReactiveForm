//
//  Keyboard.swift
//  SmartSpender
//
//  Created by Gunter Hager on 06/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

class Keyboard {
    
    struct HeightInfo {
        let keyboardHeight: CGFloat
        let animationDuration: TimeInterval
        let animationOptions: UIView.AnimationOptions
    }

    static let shared = Keyboard()
    
    let heightInfo = MutableProperty<HeightInfo>(HeightInfo(keyboardHeight: 0, animationDuration: 0, animationOptions: []))
    
    init() {
        NotificationCenter.default
            .reactive.notifications(forName: UIResponder.keyboardWillShowNotification, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification)
        }
        
        NotificationCenter.default
            .reactive.notifications(forName: UIResponder.keyboardWillHideNotification, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification, height: 0)
        }
        
        NotificationCenter.default
            .reactive.notifications(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification)
        }
    }
    
    func updateInfoWithNotification(_ notification: Notification, height: CGFloat? = nil) {
        let userInfo = notification.userInfo!
        
        let animationDuration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = height ?? keyboardEndFrame.height
        let options = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))

        heightInfo.value = HeightInfo(keyboardHeight: keyboardHeight, animationDuration: animationDuration, animationOptions: options)
    }

}
