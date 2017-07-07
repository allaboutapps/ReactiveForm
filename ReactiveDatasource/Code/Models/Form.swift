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

class Form {
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    var dataSource: DataSource
    
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
    
    var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var fields = [String : [Field]]()
    
    public func setup() {
        updateFields()
        updateChange()
    }
    
    private func updateFields() {
        fields.removeAll()
        for section in dataSource.sections {
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
    
    class Field: Diffable {
        let id: String
        let isHidden = MutableProperty(false)
        let validationState = MutableProperty<ValidationState>(.success)
        
        var anyValue: Any? = nil
        
        init(id: String) {
            self.id = id
        }
        
        var diffIdentifier: String {
            return id
        }
        
        func isEqualToDiffable(_ other: Diffable?) -> Bool {
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
    
    class TextField: Form.Field {
        let text: MutableProperty<String?>
        let placeholder: String?
        let configureTextInputTraits: ((UITextField) -> Void)?
        
        init(id: String, text: String? = nil, placeholder: String? = nil, bindings: ((TextField) -> Void)? = nil, configureTextInputTraits: ((UITextField) -> Void)? = nil) {
            self.text = MutableProperty(text)
            self.placeholder = placeholder
            self.configureTextInputTraits = configureTextInputTraits
            super.init(id: id)
            
            self.text.signal.observeValues { [unowned self] _ in
                self.notifyChanged()
            }
            
            bindings?(self)
        }
        
        override var anyValue: Any? {
            get {
                return text.value
            }
            set(value) {
                text.value = value as! String?
            }
        }
        
        override func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? TextField else { return false }
            
            return super.isEqualToDiffable(other)
                && self.text.value == other.text.value
                && self.placeholder == other.placeholder
        }
    }
    
    class SwitchField: Form.Field {
        let title: String
        var isOn: MutableProperty<Bool>
        
        init(id: String, title: String, isOn: Bool = false, bindings: ((SwitchField) -> Void)? = nil) {
            self.title = title
            self.isOn = MutableProperty(isOn)
            super.init(id: id)
            
            bindings?(self)
        }
        
        override var anyValue: Any? {
            get {
                return isOn.value
            }
            set(value) {
                isOn.value = value as! Bool
            }
            
        }
        
        override func isEqualToDiffable(_ other: Diffable?) -> Bool {
            guard let other = other as? SwitchField else { return false }
            
            return super.isEqualToDiffable(other)
                && self.title == other.title
                && self.isOn.value == other.isOn.value
        }
    }
    
    class ValidationField: Form.Field {
        let displayedState = MutableProperty<ValidationState>(.success)
    }
}

// MARK: - Util

enum ValidationState {
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
    
    func validationField() -> Form.ValidationField {
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
