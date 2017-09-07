//
//  SwitchField.swift
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
    
    public class SwitchField: Form.Field {
        public let title: String
        public var isOn: MutableProperty<Bool>
        
        public init(id: String, title: String, isOn: Bool = false, bindings: ((SwitchField) -> Void)? = nil) {
            self.title = title
            self.isOn = MutableProperty(isOn)
            super.init(id: id)
            
            self.isOn.signal.observeValues { [unowned self] _ in
                self.notifyChanged()
            }
            
            bindings?(self)
        }
        
        public override var anyValue: Any? {
            get {
                return isOn.value
            }
            set(value) {
                isOn.value = value as! Bool
            }
            
        }
        
        public override func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? SwitchField else { return false }
            
            return super.isEqualToDiffable(other)
                && self.title == other.title
                && self.isOn.value == other.isOn.value
        }
    }
    
}
