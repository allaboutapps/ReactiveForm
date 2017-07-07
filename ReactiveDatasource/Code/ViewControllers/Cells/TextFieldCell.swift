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

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var field: Form.TextField!
    
    var disposableUiToData: Disposable?
    var disposableDataToUi: Disposable?
    
    func configure(field: Form.TextField) {
        self.field = field
        
        textField.text = field.text.value
        textField.placeholder = field.placeholder
        
        textField.keyboardType = field.keyboardType
        textField.autocorrectionType = .no
        
        // Need to reset bindings on configure (cell reuse)
        disposableUiToData?.dispose()
        disposableDataToUi?.dispose()
        
        // Bind field data to UI and vise versa
        disposableUiToData = field.text <~ textField.reactive.continuousTextValues
        disposableDataToUi = textField.reactive.text <~ field.text
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
