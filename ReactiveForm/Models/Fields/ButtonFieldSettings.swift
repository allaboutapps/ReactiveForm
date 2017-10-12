//
//  ButtonFieldSettings.swift
//  
//
//  Created by Gunter Hager on 08/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

public extension Form {
    
    public enum ButtonAppearance {
        case text
        case rounded
    }
    
    public class ButtonFieldSettings: FieldSettings {
        
        public var appearance: ButtonAppearance? = nil
        public var tintColor: UIColor? = nil
        public var alignment: UIControlContentHorizontalAlignment = .center
        public var action: ((FormFieldProtocol) -> Void)?
        
    }
    
}

