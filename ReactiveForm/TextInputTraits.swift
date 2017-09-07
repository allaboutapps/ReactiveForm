//
//  TextInputTraits.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 07.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit

public class TextInputTraits {
    
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    public var autocorrectionType: UITextAutocorrectionType = .default
    public var spellCheckingType: UITextSpellCheckingType = .default
    public var keyboardType: UIKeyboardType = .default
    public var keyboardAppearance: UIKeyboardAppearance = .default
    public var returnKeyType: UIReturnKeyType = .default
    public var enablesReturnKeyAutomatically: Bool = false
    public var isSecureTextEntry: Bool = false
    public var textContentType: UITextContentType? = nil
    
    public static func create(_ configure: (TextInputTraits) -> Void) -> TextInputTraits {
        let traits = TextInputTraits()
        configure(traits)
        return traits
    }
    
    public static var defaultNameTraits: TextInputTraits {
        return create {
            $0.autocapitalizationType = .words
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
    }
    
    public static var defaultEmailTraits: TextInputTraits {
        return create {
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.keyboardType = .emailAddress
            $0.textContentType = UITextContentType.emailAddress
        }
    }
    
    public static var defaultPasswordTraits: TextInputTraits {
        return create {
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.isSecureTextEntry = true
        }
    }
    
}

extension UITextField {
    
    public func assignTraits(_ traits: TextInputTraits?) {
        guard let traits = traits else { return }
        self.autocapitalizationType = traits.autocapitalizationType
        self.autocorrectionType = traits.autocorrectionType
        self.spellCheckingType = traits.spellCheckingType
        self.keyboardType = traits.keyboardType
        self.keyboardAppearance = traits.keyboardAppearance
        self.returnKeyType = traits.returnKeyType
        self.enablesReturnKeyAutomatically = traits.enablesReturnKeyAutomatically
        self.isSecureTextEntry = traits.isSecureTextEntry
        self.textContentType = traits.textContentType
    }
}

extension UITextView {
    
    public func assignTraits(_ traits: TextInputTraits?) {
        guard let traits = traits else { return }
        self.autocapitalizationType = traits.autocapitalizationType
        self.autocorrectionType = traits.autocorrectionType
        self.spellCheckingType = traits.spellCheckingType
        self.keyboardType = traits.keyboardType
        self.keyboardAppearance = traits.keyboardAppearance
        self.returnKeyType = traits.returnKeyType
        self.enablesReturnKeyAutomatically = traits.enablesReturnKeyAutomatically
        self.isSecureTextEntry = traits.isSecureTextEntry
        self.textContentType = traits.textContentType
    }
}

