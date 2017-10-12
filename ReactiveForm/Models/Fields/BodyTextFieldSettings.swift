//
//  BodyTextFieldSettings.swift
//  
//
//  Created by Gunter Hager on 20/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

public extension Form {
    
    /// Settings that define various aspects of a content field, like e.g. the input traits of a text field.
    public class BodyTextFieldSettings: FieldSettings {
        
        public var spacingAbove: CGFloat = 10
        public var spacingBelow: CGFloat = 16
        public var padding: UIEdgeInsets = .zero
        public var font: UIFont?
        public let textColor = MutableProperty<UIColor?>(nil)
        public let icon = MutableProperty<UIImage?>(nil)
        public let backgroundColor = MutableProperty<UIColor?>(nil)
        
        public init(spacingAbove: CGFloat = 10, spacingBelow: CGFloat = 16, padding: UIEdgeInsets = .zero, font: UIFont? = nil, textColor: UIColor? = nil, icon: UIImage? = nil, backgroundColor: UIColor? = nil) {
            self.spacingAbove = spacingAbove
            self.spacingBelow = spacingBelow
            self.padding = padding
            self.font = font
            self.textColor.value = textColor
            self.icon.value = icon
            self.backgroundColor.value = backgroundColor
        }
    }
    
}

