//
//  SliderCell.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 08.04.19.
//  Copyright © 2019 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource

public class SliderCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var valueLabel: UILabel!
    @IBOutlet public weak var slider: UISlider!
    
    public func configure(field: FormField<Double>) {
        super.configure(field: field)
        guard field.type == .slider else { return }
        
        disposable += titleLabel.reactive.text <~ field.title
        
        disposable += valueLabel.reactive.text <~ field.content.map { value -> String in
            let displayValue = value ?? 0
            guard let settings = field.settings as? SliderFieldSettings,
                let formatter = settings.formatterClosure else { return String(displayValue) }
            return formatter(displayValue) ?? String(displayValue)
        }
        
        slider.value = Float(field.content.value ?? 0)
        disposable += field.content <~ slider.reactive.values.map { Double($0) }
        if let settings = field.settings as? SliderFieldSettings {
            slider.minimumValue = Float(settings.minimumValue)
            slider.maximumValue = Float(settings.maximumValue)
        }
        
        disposable += field.validationState <~ field.content.map { value -> ValidationState in
            return field.validate(value: value)
        }
        disposable += field.validationState <~ field.validationRule.map { (rule) -> ValidationState in
            return field.validate(value: field.content.value)
        }
        
    }
    
}

public extension SliderCell {
    
    static var descriptor: CellDescriptor<FormField<Double>, SliderCell> {
        return CellDescriptor("SliderCell", bundle: Bundle(for: SliderCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
