//
//  TitleFieldSettings.swift
//  
//
//  Created by Gunter Hager on 18/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

/// Settings that define various aspects of a content field, like e.g. the input traits of a text field.
public class TitleFieldSettings: FormFieldSettings {
    
    public var spacingAbove: CGFloat = 10
    public var spacingBelow: CGFloat = 16
    public var font: UIFont?
    
    public init(spacingAbove: CGFloat = 10, spacingBelow: CGFloat = 16, font: UIFont? = nil) {
        self.spacingAbove = spacingAbove
        self.spacingBelow = spacingBelow
        self.font = font
    }
}
