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

open class Form {
    
    public var dataSource: DataSource
    public weak var viewController: (UIViewController & FormViewController)?
    
    public init(cellDescriptors: [CellDescriptorType] = [], sectionDescriptors: [SectionDescriptorType] = [], registerNibs: Bool = true, viewController: (UIViewController & FormViewController)? = nil) {
        let defaultCellDescriptors: [CellDescriptorType] =
            [
                PickerCell.descriptor,
                SegmentedCell.descriptor,
                StepperCell.descriptor,
                ToggleCell.descriptor,
                ValidationCell.descriptor
                ]
                + TextFieldCell.descriptors

        self.dataSource = DataSource(cellDescriptors: defaultCellDescriptors + cellDescriptors, sectionDescriptors: sectionDescriptors, registerNibs: registerNibs)
        self.viewController = viewController

    }
    
    // MARK: - Validation
    
    public let validationState = MutableProperty<ValidationState>(.success)
    public lazy var isValid: Property<Bool> = {
        let producer = validationState.producer.map { state -> Bool in
            if case ValidationState.success = state {
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
    
    public func importFieldData(from keyedValues: [String: Any?]) {
        let keyedFields = fields
            .reduce(into: [:]) { (result: inout [String: FormFieldProtocol], field) in
                result[field.identifier] = field
        }
        keyedValues.forEach { (key, value) in
            if let field = keyedFields[key], field.isExportable {
                field.importContent(value)
            }
        }
    }

    public func exportFieldData(with filter: ((FormFieldProtocol) -> Bool)? = nil) -> [String: Any?] {
        return fields
            .reduce(into: [:]) { (result: inout [String: Any?], field) in
                guard field.isExportable else { return }
                guard filter?(field) ?? true else { return }
                result[field.identifier] = field.exportContent()
        }
    }
    
    public var onSubmit: ((_ data: [String: Any?], _ sender: FormFieldProtocol?) -> Void)? = nil
    
    public func submit(sender: FormFieldProtocol? = nil) {
        onSubmit?(exportFieldData(), sender)
    }
    
    // MARK: - Change
    
    public var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var enableDisposable: Disposable?
    private var isValidDisposable: Disposable?

    internal var fields = [FormFieldProtocol]()
    internal var hideables = [Hideable]()

    public func setSections(sections: [SectionType]) {
        dataSource.sections = sections
        updateFieldsAndHideables()
        setFormOnFields()
        updateChange()
        updateEnabled()
        updateIsValid()
    }
    
    private func updateFieldsAndHideables() {
        guard let sections = dataSource.sections as? [Section] else { return }
        fields = sections.reduce(into: []) { (result: inout [FormFieldProtocol], section) in
            result += section.fields()
        }
        hideables = sections.reduce(into: []) { (result: inout [Hideable], section) in
            result += section.hideables()
        }
    }
    
    private func setFormOnFields() {
        fields.forEach { (item) in
            var field = item
            field.form = self
        }
    }
    
    private func updateChange() {
        changeDisposable?.dispose()
        changeDisposable =  SignalProducer
            .combineLatest(hideables.map { $0.isHidden.producer })
            .throttle(0, on: QueueScheduler.main)
            .combinePrevious(hideables.map { $0.isHidden.value })
            .startWithValues { [weak self] (isHiddenFlags, previousHiddenFlags) in
                guard let `self` = self else { return }
                if isHiddenFlags != previousHiddenFlags {
                    // Reload table view
                    guard let tableView = self.viewController?.tableView else { return }
                    self.dataSource.reloadDataAnimated(tableView,
                                                       rowDeletionAnimation: .fade,
                                                       rowInsertionAnimation: .fade,
                                                       rowReloadAnimation: .none)
                    
                    self.didChange?()

                    // Fix: Reload of input views cause tableview reload animation to bug
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        self.updateReturnKeys()
                    })
                }
        }
    }
    
    private func updateEnabled() {
        enableDisposable?.dispose()
        enableDisposable = SignalProducer
            .combineLatest(fields.map { $0.isEnabled.producer })
            .startWithValues { [weak self] (values) in
                guard let `self` = self else { return }
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
    
    public var returnKey: UIReturnKeyType = .send
    public var nextKey: UIReturnKeyType = .next
    public var defaultKey: UIReturnKeyType = .default
    
    private func updateReturnKeys() {
        focusableFields.forEach { $0.configureReturnKey?() }
    }
    
}

public extension Section {
    func fields() -> [FormFieldProtocol] {
        let result = rows.reduce(into: []) { (result: inout [FormFieldProtocol], row) in
            if let field = row.item as? FormFieldProtocol {
                result.append(field)
            }
        }
        return result
    }
    
    func hideables() -> [Hideable] {
        let result = rows.reduce(into: []) { (result: inout [Hideable], row) in
            if let item = row.item as? Hideable {
                result.append(item)
            }
        }
        return result
    }
}
