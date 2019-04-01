//
//  TextFieldSettings.swift
//  
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

open class TextFieldSettings: FormFieldSettings, UITextInputTraits {
    
    override open var isFocusable: Bool { return true }
    
    /// Trims whitespace at start and end of string.
    public var shouldTrim: Bool = false
    
    public var keyboardType: UIKeyboardType = .default
    public var keyboardAppearance: UIKeyboardAppearance = .default
    public var returnKeyType: UIReturnKeyType = .default
    public var textContentType: UITextContentType? = nil
    public var isSecureTextEntry: Bool = false
    public var enablesReturnKeyAutomatically: Bool = false
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var autocorrectionType: UITextAutocorrectionType = .default
    public var spellCheckingType: UITextSpellCheckingType = .default
}

public extension UITextField {
    
    func assignTraits(_ traits: UITextInputTraits?) {
        self.autocapitalizationType = traits?.autocapitalizationType ?? .none
        self.autocorrectionType = traits?.autocorrectionType ?? .default
        self.spellCheckingType = traits?.spellCheckingType ?? .default
        self.keyboardType = traits?.keyboardType ?? .default
        self.keyboardAppearance = traits?.keyboardAppearance ?? .default
        self.returnKeyType = traits?.returnKeyType ?? .default
        self.enablesReturnKeyAutomatically = traits?.enablesReturnKeyAutomatically ?? false
        self.isSecureTextEntry = traits?.isSecureTextEntry ?? false
        if let textContentType = traits?.textContentType {
            self.textContentType = textContentType
        } else {
            self.textContentType = nil
        }
    }
}

public extension UITextView {
    
    func assignTraits(_ traits: UITextInputTraits?) {
        self.autocapitalizationType = traits?.autocapitalizationType ?? .none
        self.autocorrectionType = traits?.autocorrectionType ?? .default
        self.spellCheckingType = traits?.spellCheckingType ?? .default
        self.keyboardType = traits?.keyboardType ?? .default
        self.keyboardAppearance = traits?.keyboardAppearance ?? .default
        self.returnKeyType = traits?.returnKeyType ?? .default
        self.enablesReturnKeyAutomatically = traits?.enablesReturnKeyAutomatically ?? false
        self.isSecureTextEntry = traits?.isSecureTextEntry ?? false
        if let textContentType = traits?.textContentType {
            self.textContentType = textContentType
        } else {
            self.textContentType = nil
        }
    }
}
