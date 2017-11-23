//
//  FormFieldSettings.swift
//  
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation

/// Settings that define various aspects of a content field, like e.g. the input traits of a text field.
open class FormFieldSettings: NSObject {
    
    open var isFocusable: Bool { return false }
    open var isExportable: Bool { return true }
    
}
