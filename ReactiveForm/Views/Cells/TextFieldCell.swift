//
//  TextFieldCell.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift
import ReactiveCocoa

public class TextFieldCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    
    let contentBuffer = MutableProperty<String?>(nil)
    
    override public func configure<T>(field: FormField<T>) {
        super.configure(field: field)
        guard field.type == .textField else { return }
        
        disposable += titleLabel.reactive.text <~ field.title.map { $0 + (field.isRequired ? "*" : "") }
        disposable += textField.reactive.placeholder <~ field.title
        textField.reactive.isEnabled <~ field.isEnabled
        textField.delegate = self
        
        if let value = field.content.value {
            contentBuffer.value = value.stringValue
        } else {
            contentBuffer.value = nil
        }
        
        // Bind field data to UI and vise versa
        if let settings = field.settings as? TextFieldSettings {
            textField.assignTraits(settings)
            if settings.shouldTrim {
                disposable += contentBuffer <~ textField.reactive.continuousTextValues.map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            } else {
                disposable += contentBuffer <~ textField.reactive.continuousTextValues
            }
        }
        
        disposable += textField.reactive.text <~ contentBuffer
        disposable += textField.reactive.isEnabled <~ field.isEnabled
        disposable += contentBuffer.producer.startWithValues { value in
            if let value = value {
                field.setContent(T.create(from: value))
            } else {
                field.setContent(nil)
            }
            field.validationState.value = field.validate(value: field.content.value)
        }
        
        // Set Focus
        field.focus = {
            self.textField.becomeFirstResponder()
        }
        
        // Return key
        configureReturnKey()
        field.configureReturnKey = configureReturnKey
    }
    
    private func getContent<T: LosslessStringConvertible>(_ value: String?) -> T? {
        guard let value = value else { return nil }
        return T(value)
    }
    
    public func configureReturnKey() {
        if !field.isHidden.value && field.isEnabled.value {
            textField.returnKeyType = (field.nextFocusableField == nil) ? field.form.returnKey : .next
            textField.reloadInputViews()
        }
    }
    
}

public extension TextFieldCell {
    
    public static var descriptors: [CellDescriptorType] {
        return [
            CellDescriptor<FormField<Int>, TextFieldCell>("IntTextFieldCell", cellIdentifier: "TextFieldCell", bundle: Bundle(for: TextFieldCell.self))
                .configure { (field, cell, _) in
                    cell.configure(field: field)
                }
                .isHidden { (field, indexPath) in
                    return field.isHidden.value
            },
            CellDescriptor<FormField<Double>, TextFieldCell>("DoubleTextFieldCell", cellIdentifier: "TextFieldCell", bundle: Bundle(for: TextFieldCell.self))
                .configure { (field, cell, _) in
                    cell.configure(field: field)
                }
                .isHidden { (field, indexPath) in
                    return field.isHidden.value
            },
            CellDescriptor<FormField<String>, TextFieldCell>("StringTextFieldCell", cellIdentifier: "TextFieldCell", bundle: Bundle(for: TextFieldCell.self))
                .configure { (field, cell, _) in
                    cell.configure(field: field)
                }
                .isHidden { (field, indexPath) in
                    return field.isHidden.value
            }
        ]
    }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if field.isLastFocuFocusableField {
            field.form.submit(sender: field)
            return true
        } else {
            field.nextFocusableField?.focus?()
            return false
        }
    }
}
