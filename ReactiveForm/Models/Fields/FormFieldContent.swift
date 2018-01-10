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

private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

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
        return numberFormatter.number(from: content)?.floatValue ?? 0
    }
    
}

extension Double: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return numberFormatter.number(from: content)?.doubleValue ?? 0
    }
    
}

extension CGFloat: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        let value = numberFormatter.number(from: content)?.doubleValue ?? 0
        return CGFloat(value)
    }
    
}

extension String: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return String(content)
    }
    
}
