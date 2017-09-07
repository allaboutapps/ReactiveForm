//
//  Field.swift
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
    
    public class Field: Diffable {
        public weak var form: Form!
        public let id: String
        public let isHidden = MutableProperty(false)
        public let validationState = MutableProperty<ValidationState>(.success)
        public let isEnabled = MutableProperty(true)
        
        public var anyValue: Any? = nil
        
        public init(id: String) {
            self.id = id
        }
        
        
        private let _changed = Signal<Form.Field, NoError>.pipe()
        var changed: Signal<Form.Field, NoError> {
            return _changed.output
        }
        
        func notifyChanged() {
            _changed.input.send(value: self)
        }
        
        public var index: Int {
            let _myIndex =  form.fields.index { self.id == $0.id }
            guard let myIndex = _myIndex else { fatalError("") } 
            return myIndex
        }
        
        public var nextField: Field? {
            let nextIndex = index + 1
            guard nextIndex < form.fields.count else { return nil }
            return form.fields[nextIndex]
        }
        
        public var previousField: Field? {
            let nextIndex = index - 1
            guard nextIndex >= 0 else { return nil }
            return form.fields[nextIndex]
        }
        
        
        public var diffIdentifier: String {
            return id
        }
        
        public func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? Form.Field else { return false }
            return self.id == other.id
        }
        
    }
    
}

extension Form.Field: Equatable {
    
    public static func ==(lhs: Form.Field, rhs: Form.Field) -> Bool {
        return lhs.id == rhs.id
    }
    
}
