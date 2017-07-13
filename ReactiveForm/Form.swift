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
        let fieldDict = fields
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
        return fields
            .reduce([String : Any?]()) { (dict, field) in
                guard !(field is ValidationField) else { return dict }
                guard filter?(field) ?? true else { return dict }
                var varDict = dict
                varDict[field.id] = field.anyValue
                return varDict
        }
    }
    
    public var onSubmit: ((_ data: [String : Any?], _ sender: Form.Field?) -> Void)? = nil
    
    public func submit(sender: Form.Field? = nil) {
        onSubmit?(exportFieldData(), sender)
    }
    
    // MARK: - Change
    
    public var sections = [SectionType]()
    
    public var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var enableDisposable: Disposable?
    
    internal var fields = [Field]()
    
    public func setup() {
        updateFields()
        setFormOnFields()
        updateChange()
        updateEnabled()
    }
    
    private func updateFields() {
        fields.removeAll()
        for section in sections {
            if let dataSourceSection = section as? Section {
                let fieldsFromSection = dataSourceSection.fields()
                fields.append(contentsOf: fieldsFromSection)
            }
        }
    }
    
    private func setFormOnFields() {
        fields.forEach { (field) in
            field.form = self
        }
    }
    
    private func updateChange() {
        changeDisposable?.dispose()
        changeDisposable =  SignalProducer
            .combineLatest(fields.map { $0.isHidden.producer })
            .throttle(0, on: QueueScheduler.main)
            .combinePrevious(fields.map { $0.isHidden.value })
            .startWithValues { [unowned self] (isHiddenFlags, previousHiddenFlags) in
                if isHiddenFlags != previousHiddenFlags {
                    print("reload UI")
                    
                    // Fix: Reload of input views cause tableview reload animation to bug
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: { 
                        self.updateReturnKeys()
                    })
                    self.didChange?()
                }
        }
    }
    
    private func updateEnabled() {
        enableDisposable?.dispose()
        enableDisposable = SignalProducer
            .combineLatest(fields.map { $0.isEnabled.producer })
            .startWithValues { [unowned self] (values) in
                self.updateReturnKeys()
            }
    }
    
    // MARK: - Return key
    
    public var returnKey: UIReturnKeyType = .send
    
    private func updateReturnKeys() {
        focusableFields.forEach { $0.configureReturnKey?() }
    }
    
    // MARK: - Field
    
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
        
        public var index: Int {
            let _myIndex =  form.fields.index { self.id == $0.id }
            guard let myIndex = _myIndex else { fatalError() } // Field not found in form
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
        
    }
    
    // MARK: - Sub fields
    
    public class TextField: Form.Field, Focusable {
        public let text: MutableProperty<String?>
        public let placeholder: String?
        public let textInputTraits: TextInputTraits?
        
        public var focus: (() -> Void)? = nil
        public var configureReturnKey: (() -> Void)? = nil
        
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
