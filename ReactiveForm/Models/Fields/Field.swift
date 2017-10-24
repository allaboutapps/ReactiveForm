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

public extension Form {
    
    public enum FieldType: String, Decodable {
        case title
        case bodyText
        case image
        case textField
        case picker
        case button
        case toggle
        case stepper
        
        case activityIndicator
        
        case spacer
        case validation
        
        public var cellIdentifier: String {
            guard let first = rawValue.first else { return "" }
            let upperFirst = String(first).localizedUppercase + rawValue.dropFirst()
            return "\(String(upperFirst))Cell"
        }
    }
    
    public class Field<T: FormFieldContent>: FormFieldProtocol, Equatable, Diffable {

        public let identifier: String
        
        public var isFocusable: Bool {
            return settings?.isFocusable ?? false
        }
        
        public weak var form: Form!
        
        public var isRequired = false
        public let isHidden = MutableProperty(false)
        public let isEnabled = MutableProperty(true)

        public let type: FieldType
        public var cellIdentifier: String {
            let result = { () -> String in
                switch type {
                case .textField:
                    return "\(T.self)" + type.cellIdentifier
                default:
                    return type.cellIdentifier
                }
            }()
//            print(result)
            return result
        }
        
        public let title = MutableProperty("")
        public let descriptionText = MutableProperty<String?>(nil)
        
        public let content = MutableProperty<T?>(nil)
        
        public var settings: FieldSettings?
        
        public var configureReturnKey: (() -> Void)?
        public var focus: (() -> Void)?

        public let validationErrorText: String?
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
        public var validationRule: String?
        
        public init(identifier: String = UUID().uuidString, type: FieldType, title: String, descriptionText: String? = nil, content: T? = nil, settings: FieldSettings? = nil, isRequired: Bool = false, validationRule: String? = nil, validationErrorText: String? = nil) {
            self.identifier = identifier
            self.type = type
            self.title.value = title
            self.descriptionText.value = descriptionText
            self.content.value = content
            self.settings = settings
            self.isRequired = isRequired
            self.validationRule = validationRule
            self.validationErrorText = validationErrorText

            if validationRule != nil {
                validationState.value = validate(value: content)
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
        
        public func configure(_ configureClosure: (Field<T>) -> Form.FieldSettings?) -> Field<T> {
            settings = configureClosure(self)
            return self
        }
        
        public func buttonAction(_ action: @escaping (FormFieldProtocol) -> Void) -> Field<T> {
            //        settings = configureClosure(self)
            if type == .button {
                let buttonSettings = (settings as? Form.ButtonFieldSettings) ?? Form.ButtonFieldSettings()
                buttonSettings.action = action
                settings = buttonSettings
            }
            return self
        }

        // MARK: Equatable

        public static func ==(lhs: Field<T>, rhs: Field<T>) -> Bool {
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
            let settings = Form.ValidationFieldSettings()
            let validationField = Form.Field<Empty>(identifier: self.identifier + ".validation", type: .validation, title: "Validation", settings: settings, validationErrorText: validationErrorText)
            SignalProducer.combineLatest(validationState.producer, isHidden.producer)
                .startWithValues { (validationState, isHidden) in
                    
                    settings.displayedState.value = validationState
                    
                    if isHidden || settings.isInitial {
                        // Hide validation field if dependent field is hidden
                        validationField.isHidden.value = true
                        settings.isInitial = false
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
    
}

