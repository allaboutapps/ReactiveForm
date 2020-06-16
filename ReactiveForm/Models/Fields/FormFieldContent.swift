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
        return numberFormatter.number(from: content)?.floatValue
    }
    
    public var stringValue: String {
        return numberFormatter.string(for: self) ?? "\(self)"
    }
    
}

extension Double: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        return numberFormatter.number(from: content)?.doubleValue
    }
    
    public var stringValue: String {
        return numberFormatter.string(for: self) ?? "\(self)"
    }
    
}

extension CGFloat: FormFieldContent {
    
    public static func create(from content: String) -> FormFieldContent? {
        guard let value = numberFormatter.number(from: content)?.doubleValue else { return nil }
        return CGFloat(value)
    }
    
    public var stringValue: String {
        return numberFormatter.string(for: self) ?? "\(self)"
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
