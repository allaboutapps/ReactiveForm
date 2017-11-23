//
//  StepperCell.swift
//  
//
//  Created by Gunter Hager on 24.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource

public class StepperCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    @IBOutlet public weak var valueLabel: UILabel!
    @IBOutlet public weak var stepper: UIStepper!

    public func configure(field: FormField<Double>) {
        super.configure(field: field)
        guard field.type == .stepper else { return }

        disposable += titleLabel.reactive.text <~ field.title
        disposable += subtitleLabel.reactive.text <~ field.descriptionText
        disposable += subtitleLabel.reactive.isHidden <~ field.descriptionText.map { $0 == nil }

        disposable += valueLabel.reactive.text <~ field.content.map { value -> String in
            let displayValue = value ?? 0
            guard let settings = field.settings as? StepperFieldSettings,
                let formatter = settings.formatterClosure else { return String(displayValue) }
            return formatter(displayValue) ?? String(displayValue)
        }
        
        stepper.value = field.content.value ?? 0
        disposable += field.content <~ stepper.reactive.values
        if let settings = field.settings as? StepperFieldSettings {
            stepper.stepValue = settings.stepValue
            stepper.minimumValue = settings.minimumValue
            stepper.maximumValue = settings.maximumValue
        }
        
        disposable += field.validationState <~ field.content.map { value -> ValidationState in
            return field.validate(value: value)
        }
    }
    
}

public extension StepperCell {
    
    public static var descriptor: CellDescriptor<FormField<Double>, StepperCell> {
        return CellDescriptor("StepperCell", bundle: Bundle(for: StepperCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
