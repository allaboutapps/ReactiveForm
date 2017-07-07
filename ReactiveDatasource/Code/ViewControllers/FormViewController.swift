//
//  FormViewController.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 05.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

// MARK: - View Controller

class FormViewController: UITableViewController {
    
    lazy var firstNameField: Form.TextField = {
        Form.TextField(id: "firstname", placeholder: "First Name", bindings: { (field) in
            field.validationState <~ field.text.producer.map { (text) in
                if let text = text {
                    if text.characters.count > 5 {
                        return .warning(text: "more than 5")
                    } else if text.characters.count > 3 {
                        return .error(text: "more than 3")
                    }
                }
                
                return .success
            }
            
        })
    }()
    
    lazy var middleNameField: Form.TextField = {
        Form.TextField(id: "middlename", placeholder: "Middle Name",
            bindings: { (field) in
                self.firstNameField.text.producer.startWithValues { (text) in
                    field.isHidden.value = text?.isEmpty ?? true
                }
                
                field.validationState <~ field.text.producer.map { (text) in
                    if let text = text {
                        if text.characters.count > 3 {
                            return .warning(text: "more than 3")
                        } else if text.characters.count > 2 {
                            return .error(text: "more than 2")
                        }
                    }
                    
                    return .success
                }
            }
        )
    }()
    
    lazy var lastNameField: Form.TextField = {
        Form.TextField(id: "lastname", placeholder: "Last Name",
            bindings: { (field) in
                field.isHidden <~ self.firstNameField.text.producer.map {
                    $0?.isEmpty ?? true
                }
                
                field.text <~ self.firstNameField.text
            }
        )
    }()
    
    lazy var switchField: Form.SwitchField = {
        Form.SwitchField(id: "additional", title: "Show additional options")
    }()
    
    lazy var emailField: Form.TextField = {
        Form.TextField(id: "email", placeholder: "E-Mail", keyboardType: .emailAddress)
    }()
    
    lazy var dataSource: DataSource = {
        DataSource(
            cellDescriptors: [
                TextFieldCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                },
                SwitchCell.descriptor,
                TitleCell.descriptor,
                ValidationCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                }
                ],
            sectionDescriptors: [
                SectionDescriptor<Void>("section-name")
                    .headerHeight { .zero },
                
                SectionDescriptor<Void>("section-additional")
                    .header {
                        .title("Additional Fields")
                    }
                    .footer {
                        .title("Here are some additional fields")
                    }
                    .isHidden {
                        !self.switchField.isOn.value
                }
            ])
    }()
    
    var form = Form()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        form.sections = [
            Section(items: [
                firstNameField,
                firstNameField.validationField(),
                middleNameField,
                middleNameField.validationField(),
                lastNameField,
                switchField
                ]).with(identifier: "section-name"),
            
            Section(items: [
                emailField,
                "some random text"
                ]).with(identifier: "section-additional")
        ]
    
        form.didChange = {
            self.reloadUI()
        }
        
        dataSource.sections = form.sections
        
        switchField.isOn.producer.startWithValues { value in
            self.reloadUI()
        }
        
        dataSource.reloadData(tableView, animated: false)
        
        print("Exported field data:", form.exportFieldData())
    }
    
    func reloadUI() {
        dataSource.reloadData(tableView, animated: true)
    }
}

// MARK: - Form

enum ValidationState {
    case success
    case info(text: String?)
    case warning(text: String?)
    case error(text: String?)
}

class Form {
    
    init() {}
    
    var changeDisposable: Disposable?
    
    var sections = [SectionType]() {
        didSet {
            updateFields()
            updateChange()
        }
    }
    
    var fields = [String : [Field]]()
    
    var didChange: (() -> Void)? = nil
    
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
    
    class TextField: Form.Field {
        let text: MutableProperty<String?>
        let placeholder: String?
        let keyboardType: UIKeyboardType
        
        init(id: String, text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .default, bindings: ((TextField) -> Void)? = nil) {
            self.text = MutableProperty(text)
            self.placeholder = placeholder
            self.keyboardType = keyboardType
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
                && self.keyboardType == other.keyboardType
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
