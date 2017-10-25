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
        disposable += subtitleLabel.reactive.text <~ field.descriptionText
        disposable += subtitleLabel.reactive.isHidden <~ field.descriptionText.map { $0 == nil }

        disposable += valueLabel.reactive.text <~ field.content.map { value -> String in
            let displayValue = value ?? 0
            guard let settings = field.settings as? Form.StepperFieldSettings,
                let formatter = settings.formatterClosure else { return String(displayValue) }
            return formatter(displayValue) ?? String(displayValue)
        }
        
        // Enable stepper buttons only if we don't hit min/max values
        disposable += stepDownButton.reactive.isEnabled <~ field.content.map { value -> Bool in
            guard let settings = field.settings as? Form.StepperFieldSettings else { return true }
            let newValue = (field.content.value ?? 0) - settings.stepValue
            return newValue >= settings.minValue
        }
        disposable += stepUpButton.reactive.isEnabled <~ field.content.map { value -> Bool in
            guard let settings = field.settings as? Form.StepperFieldSettings else { return true }
            let newValue = (field.content.value ?? 0) + settings.stepValue
            return newValue <= settings.maxValue
        }

        disposable += field.validationState <~ field.content.map { value -> Form.ValidationState in
            return field.validate(value: value)
        }
    }
    
    @IBAction func stepDown(_ sender: Any?) {
        guard let settings = field.settings as? Form.StepperFieldSettings else { return }
        guard let field = field as? Form.Field<Double> else { return }
        let newValue = (field.content.value ?? 0) - settings.stepValue
        guard newValue >= settings.minValue else { return }
        field.content.value = newValue
    }
    
    @IBAction func stepUp(_ sender: Any?) {
        guard let settings = field.settings as? Form.StepperFieldSettings else { return }
        guard let field = field as? Form.Field<Double> else { return }
        let newValue = (field.content.value ?? 0) + settings.stepValue
        guard newValue <= settings.maxValue else { return }
        field.content.value = newValue
    }
    
}

extension StepperCell {
    
    static var descriptor: CellDescriptor<Form.Field<Double>, StepperCell> {
        return CellDescriptor("StepperCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}



