//
//  ContentField.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift
import DataSource

public enum FormFieldType: Decodable, Equatable {
    
    // Input
    case textField
    case picker
    case segmented
    case stepper
    case toggle
    
    // Custom
    case custom(String)
    
    // Validation
    case validation
    
    public var rawValue: String {
        switch self {
        case let .custom(identifier):
            return identifier
        default:
            return String(describing: self)
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "textField": self = .textField
        case "picker": self = .picker
        case "segmented": self = .segmented
        case "stepper": self = .stepper
        case "toggle": self = .toggle
        case "validation": self = .validation
            
        default: return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let value = FormFieldType(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value not found in enum cases.")
        }
        self = value
    }
    
    public var cellIdentifier: String {
        guard let first = rawValue.first else { return "" }
        let upperFirst = String(first).localizedUppercase + rawValue.dropFirst()
        return "\(String(upperFirst))Cell"
    }
    
    // MARK: Equatable
    
    //swiftlint:disable operator_whitespace
    public static func ==(lhs: FormFieldType, rhs: FormFieldType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
}

public class FormField<T: FormFieldContent>: FormFieldProtocol, Equatable, Diffable {
    
    public let identifier: String
    
    public var isFocusable: Bool {
        return settings?.isFocusable ?? isTypeFocusable
    }
    
    private var isTypeFocusable: Bool {
        switch type {
        case .textField: return true
        default: return false
        }
    }
    
    public weak var form: Form!
    
    public var isRequired = false
    public let isHidden = MutableProperty(false)
    public let isEnabled = MutableProperty(true)
    
    public let type: FormFieldType
    public var customCellIdentifier: String?
    public var cellIdentifier: String {
        if let customCellIdentifier = customCellIdentifier {
            return customCellIdentifier
        }
        
        switch type {
        case .textField:
            return "\(T.self)" + type.cellIdentifier
        default:
            return type.cellIdentifier
        }
    }
    public lazy var row: RowType = {
        return Row(self, identifier: cellIdentifier)
    }()
    
    public let title = MutableProperty("")
    public let descriptionText = MutableProperty<String?>(nil)
    
    public let content = MutableProperty<T?>(nil)
    
    public var settings: FormFieldSettings?
    
    public var configureReturnKey: (() -> Void)?
    public var focus: (() -> Void)?
    
    public var validationErrorText: String?
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
    public let validationRule = MutableProperty<String?>(nil)
    
    //swiftlint:disable line_length
    public init(identifier: String = UUID().uuidString, type: FormFieldType, customCellIdentifier: String? = nil, title: String, descriptionText: String? = nil, content: T? = nil, settings: FormFieldSettings? = nil, isRequired: Bool = false, validationRule: String? = nil, validationErrorText: String? = nil) {
        self.identifier = identifier
        self.type = type
        self.customCellIdentifier = customCellIdentifier
        self.title.value = title
        self.descriptionText.value = descriptionText
        self.content.value = content
        self.settings = settings
        self.isRequired = isRequired
        self.validationRule.value = validationRule
        self.validationErrorText = validationErrorText
        
        if validationRule != nil {
            validationState.value = validate(value: content, errorText: validationErrorText)
        }
    }
    
    // MARK: Content
    
    public func setContent(_ content: FormFieldContent?) {
        self.content.value = content as? T
    }
    
    // MARK: Import and export
    
    public var isExportable: Bool {
        let isExportableType: Bool
        switch type {
        case .textField, .picker, .toggle, .stepper:
            isExportableType = true
        default:
            isExportableType = false
        }
        return settings?.isExportable ?? isExportableType
    }
    
    public func exportContent() -> Any? {
        guard isExportable else { return nil }
        return content.value
    }
    
    public func importContent(_ content: Any?) {
        guard isExportable else { return }
        guard let content = content as? T else { return }
        self.content.value = content
    }
    
    // MARK: Configuration
    
    public func configure(_ configureClosure: (FormField<T>) -> FormFieldSettings?) -> FormField<T> {
        settings = configureClosure(self)
        return self
    }
        
    // MARK: Equatable
    
    //swiftlint:disable operator_whitespace
    public static func ==(lhs: FormField<T>, rhs: FormField<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK: Diffable
    
    public var diffIdentifier: String {
        return identifier
    }
    
    public func isEqualToDiffable(_ other: Diffable?) -> Bool {
        return identifier == other?.diffIdentifier
    }
    
    // MARK: Validation
    
    public func validationField() -> FormFieldProtocol {
        let settings = ValidationFieldSettings()
        let validationField = FormField<ValidationState>(identifier: self.identifier + ".validation", type: .validation, title: "Validation", settings: settings, validationErrorText: validationErrorText)
        SignalProducer.combineLatest(validationState.producer, isHidden.producer)
            .startWithValues { (validationState, isHidden) in
                
                validationField.content.value = validationState
                
                if isHidden || settings.isInitial {
                    // Hide validation field if dependent field is hidden
                    validationField.isHidden.value = true
                    settings.isInitial = false
                } else {
                    // if dependent field is visible, hide validation field if state is success
                    switch validationState {
                    case .success:
                        validationField.isHidden.value = true
                        
                    case .info(let text):
                        validationField.isHidden.value = false
                        validationField.title.value = text ?? ""
                        
                    case .warning(let text):
                        validationField.isHidden.value = false
                        validationField.title.value = text ?? ""
                        
                    case .error(let text):
                        validationField.isHidden.value = false
                        validationField.title.value = text ?? ""
                    }
                }
        }
        
        return validationField
    }
    
}
