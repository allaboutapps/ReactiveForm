//
//  Form.swift
//  
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
    
    // MARK: - Validation
    public let validationState = MutableProperty<ValidationState>(.success)
    public lazy var isValid: Property<Bool> = {
        let producer = validationState.producer.map { state -> Bool in
            if case Form.ValidationState.success = state {
                return true
            } else {
                return false
            }
        }
        return Property<Bool>(initial: false, then: producer)
    }()

    
    /// Validation rules are defined in `JavaScript`. The form is exposed to `JavaScript` as variable named `form`. You could use a rule like `form.age > 18` to validate the value of a field in your form.
    public var validationRule: String?
    
    // MARK: - Import & Export
    
    public func importFieldData(from keyedValues: [String : Any?]) {
        let keyedFields = fields
            .reduce(into: [:]) { (result: inout [String : FormFieldProtocol], field) in
                result[field.identifier] = field
        }
        keyedValues.forEach { (key, value) in
            if let field = keyedFields[key], field.isExportable {
                field.importContent(value)
            }
        }
    }

    public func exportFieldData(with filter: ((FormFieldProtocol) -> Bool)? = nil) -> [String : Any?] {
        return fields
            .reduce(into: [:]) { (result: inout [String : Any?], field) in
                guard field.isExportable else { return }
                guard filter?(field) ?? true else { return }
                result[field.identifier] = field.exportContent()
        }
    }
    
    public var onSubmit: ((_ data: [String : Any?], _ sender: FormFieldProtocol?) -> Void)? = nil
    
    public func submit(sender: FormFieldProtocol? = nil) {
        onSubmit?(exportFieldData(), sender)
    }
    
    // MARK: - Change
    
    public var sections = [SectionType]()
    
    public var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var enableDisposable: Disposable?
    private var isValidDisposable: Disposable?

    internal var fields = [FormFieldProtocol]()
    
    public func setup() {
        updateFields()
        setFormOnFields()
        updateChange()
        updateEnabled()
        updateIsValid()
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
            var f = field
            f.form = self
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
    
    private func updateIsValid() {
        isValidDisposable?.dispose()
        isValidDisposable = SignalProducer
            .combineLatest(fields.map { $0.isValid.producer })
            .startWithValues { [weak self] values in
                guard let `self` = self else { return }
                
                // Check if all fields are valid
                let areFieldsValid = values.reduce(true) { $0 && $1 }
                guard areFieldsValid else {
                    self.validationState.value = .error(text: "Some fields are invalid")
                    return
                }
                
                // Check if the form's validation rule is valid
                guard let rule = self.validationRule else {
                    self.validationState.value = .success
                    return
                }
                let fieldData = self.exportFieldData()
                let formIsValid = Validation.shared.validate(form: fieldData, withRule: rule)
                
                self.validationState.value = formIsValid ? .success : .error(text: "Form is invalid")
        }
    }
    
    // MARK: - Return key
    
    public var shouldAdaptedReturnKey = true
    
    public var returnKey: UIReturnKeyType = .send
    public var nextKey: UIReturnKeyType = .next
    public var defaultKey: UIReturnKeyType = .default
    
    private func updateReturnKeys() {
        focusableFields.forEach { $0.configureReturnKey?() }
    }
    
}

public extension Section {
    public func fields() -> [FormFieldProtocol] {
        var fieldsFromSection: [FormFieldProtocol] = []
        for row in self.rows {
            if let field = row.item as? FormFieldProtocol {
                fieldsFromSection += [field]
            }
        }
        return fieldsFromSection
    }
}


