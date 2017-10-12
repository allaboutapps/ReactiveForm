//
//  SwitchCell.swift
//  
//
//  Created by Gunter Hager on 14/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class ToggleCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var toggle: UISwitch!
    
    func configure(field: Form.Field<Bool>) {
        super.configure(field: field)
        guard field.type == .toggle else { return }
        disposable += linkButton.reactive.title(for: .normal) <~ field.title
        
        disposable += toggle.reactive.isOn <~ field.content.map { $0 ?? false }
        disposable += field.content <~ toggle.reactive.isOnValues
        
        disposable += field.validationState <~ toggle.reactive.isOnValues.map { value -> Form.ValidationState in
            return field.validate(value: value)
        }
        
        if let settings = field.settings as? Form.ToggleFieldSettings {
            linkButton.isEnabled = (settings.link != nil)
        }

    }
    
    @IBAction func link(_ sender: Any?) {
        guard let settings = field.settings as? Form.ToggleFieldSettings else { return }
        settings.link?()
    }
    
}

extension ToggleCell {
    
    static var descriptor: CellDescriptor<Form.Field<Bool>, ToggleCell> {
        return CellDescriptor("ToggleCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


