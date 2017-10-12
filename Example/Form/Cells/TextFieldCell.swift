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
import ReactiveForm

class TextFieldCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var textField: DesignableTextField!
    
    let contentBuffer = MutableProperty<String?>(nil)

    override func configure<T>(field: Form.Field<T>) {
        super.configure(field: field)
        guard field.type == .textField else { return }
        
        disposable += field.title.producer.startWithValues { [weak self] title in
            guard let `self` = self else { return }
            let placeholder = title + (field.isRequired ? "*" : "")
            self.textField.placeholder = placeholder
            self.textField.setPlaceholderText(placeholder)
        }
        textField.reactive.isEnabled <~ field.isEnabled
        textField.delegate = self

        if let value = field.content.value {
            contentBuffer.value = "\(value)"
        } else {
            contentBuffer.value = nil
        }
        
        // Bind field data to UI and vise versa
        if let settings = field.settings as? Form.TextFieldSettings {
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
            }
        }
        
        disposable += field.validationState <~ textField.reactive.continuousTextValues.map { value -> Form.ValidationState in
            return field.validate(value: value)
        }
//        disposable += field.validationState.producer.startWithValues { [weak self] (state) in
//            guard let `self` = self else { return }
//            var lineColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
//            switch state {
//            case .error:
//                lineColor = #colorLiteral(red: 0.9292213917, green: 0.1336172819, blue: 0, alpha: 1)
//            default:
//                break
//            }
//            print(lineColor)
//            self.textField.activeLineColor = lineColor
//            self.textField.setNeedsDisplay()
//        }
        
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
    
    func configureReturnKey() {
        if (!field.isHidden.value && field.isEnabled.value) {
            textField.returnKeyType = (field.nextFocusableField == nil) ? field.form.returnKey : .next
            textField.reloadInputViews()
        }
    }

}

extension TextFieldCell {
    
    static var descriptors: [CellDescriptorType] {
        return [
            CellDescriptor<Form.Field<Double>, TextFieldCell>("DoubleTextFieldCell", cellIdentifier: "TextFieldCell")
                .configure { (field, cell, _) in
                    cell.configure(field: field)
            }
                .isHidden { (field, indexPath) in
                    return field.isHidden.value
            },
            CellDescriptor<Form.Field<String>, TextFieldCell>("StringTextFieldCell", cellIdentifier: "TextFieldCell")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if field.isLastFocuFocusableField {
            field.form.submit(sender: field)
            return true
        } else {
            field.nextFocusableField?.focus?()
            return false
        }
    }
}

