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
        let animationOptions: UIViewAnimationOptions
    }

    static let shared = Keyboard()
    
    let heightInfo = MutableProperty<HeightInfo>(HeightInfo(keyboardHeight: 0, animationDuration: 0, animationOptions: []))
    
    init() {
        NotificationCenter.default
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardWillShow, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification)
        }
        
        NotificationCenter.default
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardWillHide, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification, height: 0)
        }
        
        NotificationCenter.default
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            .observeValues { [weak self] (notification) in
                self?.updateInfoWithNotification(notification)
        }
    }
    
    func updateInfoWithNotification(_ notification: Notification, height: CGFloat? = nil) {
        let userInfo = notification.userInfo!
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = height ?? keyboardEndFrame.height
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))

        heightInfo.value = HeightInfo(keyboardHeight: keyboardHeight, animationDuration: animationDuration, animationOptions: options)
    }

}
