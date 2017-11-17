//
//  ActivityIndicatorFieldSettings.swift
//  
//
//  Created by Gunter Hager on 06/10/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

public extension Form {
    
    /// Settings that define various aspects of a content field, like e.g. the input traits of a text field.
    public class ActivityIndicatorFieldSettings: FieldSettings {
        
        public var spacingAbove: CGFloat = 10
        public var spacingBelow: CGFloat = 10
        public let isAnimating = MutableProperty(false)

        public init(spacingAbove: CGFloat = 10, spacingBelow: CGFloat = 10, isAnimating: Bool = false) {
            self.spacingAbove = spacingAbove
            self.spacingBelow = spacingBelow
            self.isAnimating.value = isAnimating
        }
    }
    
}


