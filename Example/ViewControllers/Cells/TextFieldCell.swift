//
//  TextFieldCell.swift
//  DataSource
//
//  Created by Matthias Buchetics on 28/02/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var field: Form.TextField!
    
    var disposable = CompositeDisposable()
    
    func configure(field: Form.TextField) {
        self.field = field
        
        textField.text = field.text.value
        textField.placeholder = field.placeholder
        textField.isEnabled = field.isEnabled.value
        textField.delegate = self

        textField.assignTraits(field.textInputTraits)
        
        // Bind field data to UI and vise versa
        disposable += field.text <~ textField.reactive.continuousTextValues
        disposable += textField.reactive.text <~ field.text
        disposable += textField.reactive.isEnabled <~ field.isEnabled
        
        // Set Focus
        field.focus = {
            self.textField.becomeFirstResponder()
        }
        
        // Return key
        configureReturnKey()
        field.configureReturnKey = configureReturnKey
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }
    
    func configureReturnKey() {
        if (!field.isHidden.value && field.isEnabled.value) {
            textField.returnKeyType = (field.nextFocusableField == nil) ? field.form.returnKey : .next
            textField.reloadInputViews()
        }
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

extension TextFieldCell {
    
    static var descriptor: CellDescriptor<Form.TextField, TextFieldCell> {
        return CellDescriptor()
            .configure { (field, cell, indexPath) in
                cell.configure(field: field)
        }
    }
}
