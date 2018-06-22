//
//  PickerCell.swift
//  
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift
import ReactiveCocoa

public class PickerCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: PickerTextField!
    public var pickerView = UIPickerView()
    public var toolbar = UIToolbar()
    
    public func configure(field: FormField<String>) {
        super.configure(field: field)
        guard field.type == .picker else { return }
        
        disposable += titleLabel.reactive.text <~ field.title.map { $0 + (field.isRequired ? "*" : "") }
        disposable += textField.reactive.placeholder <~ field.title
        disposable += textField.reactive.isEnabled <~ field.isEnabled
        textField.delegate = self

        // Set Focus
        field.focus = {
            self.textField.becomeFirstResponder()
        }

        if let settings = field.settings as? PickerFieldSettings {
            pickerView.dataSource = self
            pickerView.delegate = self
            textField.inputView = pickerView
            
            setupToolbar(settings: settings)
            textField.inputAccessoryView = toolbar
            
            disposable += field.content <~ settings.pickerViewModel.selectedItem.map { $0?.title }
            disposable += textField.reactive.text <~ field.content.map { $0 }
            disposable += field.validationState <~ field.content.map { value -> ValidationState in
                return field.validate(value: value)
            }
        }
        
    }
    
    private func setupToolbar(settings: PickerFieldSettings) {
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let titleLabel = UILabel()
        titleLabel.text = settings.pickerViewModel.title
        let titleItem = UIBarButtonItem(customView: titleLabel)
        let spacer1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spacer2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelItem = UIBarButtonItem(title: settings.pickerViewModel.cancelButtonTitle, style: .plain, target: self, action: #selector(cancel))
        let submitItem = UIBarButtonItem(title: settings.pickerViewModel.submitButtonTitle, style: .plain, target: self, action: #selector(submit))
        toolbar.items = [cancelItem, spacer1, titleItem, spacer2, submitItem]
    }
    
    // MARK: Actions
    
    @objc public func cancel() {
        _ = textField.delegate?.textFieldShouldReturn?(textField)
    }
    
    @objc public func submit() {
        if let settings = field.settings as? PickerFieldSettings {
            let row = pickerView.selectedRow(inComponent: 0)
            settings.pickerViewModel.selectedItem.value = settings.pickerViewModel.items[row]
        }
        _ = textField.delegate?.textFieldShouldReturn?(textField)
    }

}

extension PickerCell {
    
    public static var descriptor: CellDescriptor<FormField<String>, PickerCell> {
        return CellDescriptor("PickerCell", bundle: Bundle(for: PickerCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}

extension PickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let settings = field.settings as? PickerFieldSettings else { return 0 }
        return settings.pickerViewModel.items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let settings = field.settings as? PickerFieldSettings else { return nil }
        return settings.pickerViewModel.items[row].title
    }
    
}

extension PickerCell: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let settings = field.settings as? PickerFieldSettings else { return false }
        let selectedIndex = settings.pickerViewModel.items.index { (item) -> Bool in
            guard let propertyValue = settings.pickerViewModel.selectedItem.value else { return false }
            return item.title == propertyValue.title
        }
        
        if let selectedIndex = selectedIndex {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextFocus = field.nextFocusableField?.focus {
            nextFocus()
        } else {
            textField.endEditing(true)
        }
        return false
    }
}
