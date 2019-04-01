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
    var stringValue: String { get }
    
}

public extension FormFieldContent {
    
    static func create(from string: String) -> FormFieldContent? {
        return nil
    }
    
    var stringValue: String {
        return ""
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
    
    public var stringValue: String {
        return "\(self)"
    }
    
}

extension Float: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return numberFormatter.number(from: content)?.floatValue ?? 0
    }
    
    public var stringValue: String {
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
}

extension Double: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return numberFormatter.number(from: content)?.doubleValue ?? 0
    }
    
    public var stringValue: String {
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
}

extension CGFloat: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        let value = numberFormatter.number(from: content)?.doubleValue ?? 0
        return CGFloat(value)
    }
    
    public var stringValue: String {
        return numberFormatter.string(from: NSNumber(value: Double(self))) ?? "\(self)"
    }
    
}

extension String: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return String(content)
    }

    public var stringValue: String {
        return self
    }

}
