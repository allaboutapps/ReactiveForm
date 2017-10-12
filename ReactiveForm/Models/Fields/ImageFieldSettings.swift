//
//  ImageFieldSettings.swift
//  
//
//  Created by Gunter Hager on 26/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

public extension Form {
    
    public class ImageFieldSettings: FieldSettings {
        
        public let image = MutableProperty<UIImage?>(nil)
        public var spacingAbove: CGFloat = 10
        public var spacingBelow: CGFloat = 16
        public var width: CGFloat = 0
        
        public init(spacingAbove: CGFloat = 10, spacingBelow: CGFloat = 16, image: UIImage? = nil, width: CGFloat? = nil) {
            self.spacingAbove = spacingAbove
            self.spacingBelow = spacingBelow
            self.image.value = image
            self.width = width ?? (image?.size.width ?? 0)
        }
    }
    
}


