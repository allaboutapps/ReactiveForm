//
//  TextField.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa


extension Form {
    
    public class TextField: Form.Field, Focusable {
        public let text: MutableProperty<String?>
        public let placeholder: String?
        public let textInputTraits: TextInputTraits?
        
        public var focus: (() -> Void)? = nil
        public var configureReturnKey: (() -> Void)? = nil
        
        public init(identifier: String, text: String? = nil, placeholder: String? = nil, textInputTraits: TextInputTraits? = nil, bindings: ((TextField) -> Void)? = nil) {
            self.text = MutableProperty(text)
            self.placeholder = placeholder
            self.textInputTraits = textInputTraits
            super.init(identifier: identifier)
            
            self.text.signal.observeValues { [unowned self] _ in
                self.notifyChanged()
            }
            
            bindings?(self)
        }
        
        public override var anyValue: Any? {
            get {
                return text.value
            }
            set(value) {
                text.value = value as! String?
            }
        }
        
        public override func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? TextField else { return false }
            
            return super.isEqualToDiffable(other)
                && self.text.value == other.text.value
                && self.placeholder == other.placeholder
        }
    }

}
