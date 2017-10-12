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
import ReactiveForm

class PickerCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var textField: DesignableTextField!
    
    func configure(field: Form.Field<String>) {
        super.configure(field: field)
        guard field.type == .picker else { return }
        
        textField.placeholder = field.title.value
        textField.setPlaceholderText(field.title.value)
        textField.isUserInteractionEnabled = false
        
        if let settings = field.settings as? Form.PickerFieldSettings {
            disposable += field.content <~ settings.pickerViewModel.selectedItem.map { $0?.title }
            disposable += textField.reactive.text <~ field.content.map { $0 }
        }
    }
    
}

extension PickerCell {
    
    static var descriptor: CellDescriptor<Form.Field<String>, PickerCell> {
        return CellDescriptor("PickerCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


