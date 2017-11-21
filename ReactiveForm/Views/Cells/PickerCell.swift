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

class PickerCell: FormFieldCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func configure(field: FormField<String>) {
        super.configure(field: field)
        guard field.type == .picker else { return }
        
        disposable += titleLabel.reactive.text <~ field.title

        if let settings = field.settings as? PickerFieldSettings {
            disposable += field.content <~ settings.pickerViewModel.selectedItem.map { $0?.title }
            disposable += valueLabel.reactive.text <~ field.content.map { $0 }
        }
    }
    
}

extension PickerCell {
    
    static var descriptor: CellDescriptor<FormField<String>, PickerCell> {
        return CellDescriptor("PickerCell", bundle: Bundle(for: PickerCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


