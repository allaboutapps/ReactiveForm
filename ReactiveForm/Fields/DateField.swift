//
//  DateField.swift
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
    
    public class DateField: Form.Field {
        public var date: MutableProperty<Date?>
        public let placeholder: String?
        
        public init(id: String, placeholder: String? = nil, date: Date? = nil, bindings: ((DateField) -> Void)? = nil) {
            self.date = MutableProperty(date)
            self.placeholder = placeholder
            super.init(id: id)
            
            self.date.signal.observeValues { [unowned self] _ in
                self.notifyChanged()
            }
            
            bindings?(self)
        }
        
        public override var anyValue: Any? {
            get {
                return date.value
            }
            set(value) {
                date.value = value as! Date?
            }
        }
        
        public override func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? DateField else { return false }
            
            return super.isEqualToDiffable(other)
                && self.date.value == other.date.value
        }
    }
    
}

