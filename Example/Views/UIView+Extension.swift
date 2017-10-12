//
//  UIView+Extension.swift
//  SmartSpender
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//
import UIKit

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.2, completion:(() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: { finished in
            if let completion = completion, finished {
                completion()
            }
        })
    }
    
    func fadeOut(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { finished in
            if let completion = completion, finished {
                completion()
            }
        })
    }
    
}
