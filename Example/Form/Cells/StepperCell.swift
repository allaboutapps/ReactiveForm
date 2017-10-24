//
//  StepperCell.swift
//  Example
//
//  Created by Gunter Hager on 24.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class StepperCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepDownButton: UIButton!
    @IBOutlet weak var stepUpButton: UIButton!

    func configure(field: Form.Field<Double>) {
        super.configure(field: field)
        guard field.type == .stepper else { return }
        disposable += titleLabel.reactive.text <~ field.title
        disposable += valueLabel.reactive.text <~ field.content.map { value -> String in
            guard let value = value else { return "" }
            guard let settings = field.settings as? Form.StepperFieldSettings,
            let formatter = settings.formatter else { return String(value) }
            return formatter.string(from: value as NSNumber) ?? ""
        }
        
        disposable += field.validationState <~ field.content.map { value -> Form.ValidationState in
            return field.validate(value: value)
        }
        
        if let settings = field.settings as? Form.StepperFieldSettings {
            
        }
        
    }
    
    @IBAction func link(_ sender: Any?) {
        guard let settings = field.settings as? Form.ToggleFieldSettings else { return }
        settings.link?()
    }
    
}

extension StepperCell {
    
    static var descriptor: CellDescriptor<Form.Field<Bool>, StepperCell> {
        return CellDescriptor("StepperCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}



