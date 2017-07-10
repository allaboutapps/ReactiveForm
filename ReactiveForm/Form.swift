//
//  Form.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 07.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

public class Form {
    
    public init() {}
    
    // MARK: - Import & Export
    
    public func importFieldData(from dict:[String : Any?]) {
        let fieldDict = fields.flatMap { $1 }
            .reduce([String : Field]()) { (dict, field) in
                var varDict = dict
                varDict[field.id] = field
                return varDict
        }
        dict.forEach { (key, value) in
            if let field = fieldDict[key] {
                field.anyValue = value
            }
        }
    }
    
    public func exportFieldData(with filter: ((Field) -> Bool)? = nil) -> [String : Any?] {
        return fields.flatMap { $1 }
            .reduce([String : Any?]()) { (dict, field) in
                guard !(field is ValidationField) else { return dict }
                guard filter?(field) ?? true else { return dict }
                var varDict = dict
                varDict[field.id] = field.anyValue
                return varDict
        }
    }
    
    // MARK: - Change
    
    public var sections = [SectionType]()
    
    public var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var fields = [String : [Field]]()
    
    public func setup() {
        updateFields()
        updateChange()
    }
    
    private func updateFields() {
        fields.removeAll()
        for section in sections {
            if let dataSourceSection = section as? Section {
                let fieldsFromSection = dataSourceSection.fields()
                if !fieldsFromSection.isEmpty {
                    fields[dataSourceSection.identifier] = fieldsFromSection
                }
            }
        }
    }
    
    private func updateChange() {
        let fieldArray = fields.flatMap { $1 }
        changeDisposable?.dispose()
        changeDisposable =  SignalProducer
            .combineLatest(fieldArray.map { $0.isHidden.producer })
            .throttle(0, on: QueueScheduler.main)
            .combinePrevious(fieldArray.map { $0.isHidden.value })
            .startWithValues { [unowned self] (isHiddenFlags, previousHiddenFlags) in
                if isHiddenFlags != previousHiddenFlags {
                    print("reload UI")
                    self.didChange?()
                }
        }
    }
    
    // MARK: - Field
    
    public class Field: Diffable {
        public let id: String
        public let isHidden = MutableProperty(false)
        public let validationState = MutableProperty<ValidationState>(.success)
        
        public var anyValue: Any? = nil
        
        public init(id: String) {
            self.id = id
        }
        
        public var diffIdentifier: String {
            return id
        }
        
        public func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? Form.Field else { return false }
            
            return self.id == other.id
        }
        
        private let _changed = Signal<Form.Field, NoError>.pipe()
        var changed: Signal<Form.Field, NoError> {
            return _changed.output
        }
        
        func notifyChanged() {
            _changed.input.send(value: self)
        }
    }
    
    // MARK: - Sub fields
    
    public class TextField: Form.Field {
        public let text: MutableProperty<String?>
        public let placeholder: String?
        public let textInputTraits: TextInputTraits?
        
        public init(id: String, text: String? = nil, placeholder: String? = nil, textInputTraits: TextInputTraits? = nil, bindings: ((TextField) -> Void)? = nil) {
            self.text = MutableProperty(text)
            self.placeholder = placeholder
            self.textInputTraits = textInputTraits
            super.init(id: id)
            
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
    
    public class SwitchField: Form.Field {
        public let title: String
        public var isOn: MutableProperty<Bool>
        
        public init(id: String, title: String, isOn: Bool = false, bindings: ((SwitchField) -> Void)? = nil) {
            self.title = title
            self.isOn = MutableProperty(isOn)
            super.init(id: id)
            
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
    
    public class ValidationField: Form.Field {
        public let displayedState = MutableProperty<ValidationState>(.success)
    }
}

// MARK: - Util

public enum ValidationState {
    case success
    case info(text: String?)
    case warning(text: String?)
    case error(text: String?)
}

extension Section {
    func fields() -> [Form.Field] {
        var fieldsFromSection: [Form.Field] = []
        for row in self.rows {
            if let field = row.item as? Form.Field {
                fieldsFromSection += [field]
            }
        }
        return fieldsFromSection
    }
}

extension Form.Field {
    
    public func validationField() -> Form.ValidationField {
        let validationField = Form.ValidationField(id: self.id + ".validation")
        
        SignalProducer.combineLatest(validationState.producer, isHidden.producer)
            .startWithValues { (value) in
                let validationState = value.0
                let isHidden = value.1
                
                validationField.displayedState.value = validationState
                
                
                if isHidden {
                    // Hide validation field if dependent field is hidden
                    validationField.isHidden.value = true
                } else {
                    // if dependent field is visible, hide validation field if state is success
                    switch validationState {
                    case .success:
                        validationField.isHidden.value = true
                    default:
                        validationField.isHidden.value = false
                    }
                }
        }
        
        return validationField
    }
}
