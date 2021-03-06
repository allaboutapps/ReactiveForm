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
import UIKit

public class ToggleCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var toggle: UISwitch!
    
    public func configure(field: FormField<Bool>) {
        super.configure(field: field)
        guard field.type == .toggle else { return }
        
        disposable += titleLabel.reactive.text <~ field.title

        disposable += toggle.reactive.isOn <~ field.content.map { $0 ?? false }
        disposable += field.content <~ toggle.reactive.isOnValues
        
        disposable += field.validationState <~ toggle.reactive.isOnValues.map { value -> ValidationState in
            return field.validate(value: value)
        }
        
    }
        
}

public extension ToggleCell {
    
    static var descriptor: CellDescriptor<FormField<Bool>, ToggleCell> {
        return CellDescriptor("ToggleCell", bundle: Bundle(for: ToggleCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
