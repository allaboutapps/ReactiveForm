//
//  FieldContent.swift
//  
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

public protocol FormFieldContent {
    
    static func create(from string: String) -> FormFieldContent?
    
}

public extension FormFieldContent {
    
    public static func create(from string: String) -> FormFieldContent? {
        return nil
    }

}

// MARK: - Support for standard types

public struct Empty: FormFieldContent {
}


extension Bool: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return false
    }
    
}

extension Int: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return Int(content)
    }
    
}

extension Float: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return Float(content)
    }
    
}

extension Double: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return Double(content)
    }
    
}

extension CGFloat: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return Double(content)
    }
    
}

extension String: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return String(content)
    }
    
}

