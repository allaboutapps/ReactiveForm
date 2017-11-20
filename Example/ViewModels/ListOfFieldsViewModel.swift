//
//  ListOfFieldsViewModel.swift
//  Example
//
//  Created by Gunter Hager on 24.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveForm

enum PickerFieldOption: String, PickerItem {
    case one = "One"
    case two = "Two"
    case three = "Three"
    
    var title: String {
        return rawValue
    }
}


class ListOfFieldsViewModel: CardViewModel {
    
    let textFieldValue = MutableProperty<Double?>(nil)
    let toggleFieldValue = MutableProperty(false)
    let pickerFieldValue = MutableProperty<PickerFieldOption?>(nil)
    let stepperFieldValue = MutableProperty<Double?>(nil)

    
    override init() {
        super.init()
        
        tintColor = #colorLiteral(red: 0.6156862745, green: 0.7803921569, blue: 0.2392156863, alpha: 1)
        let backgroundColor: UIColor = #colorLiteral(red: 0.8690528274, green: 0.8690528274, blue: 0.8690528274, alpha: 1)
        
        let fields: [FormFieldProtocol] = [
            FormField<Empty>(type: .title, title: "Title"),

            FormField<Empty>(type: .bodyText, title: "BodyText")
                .configure { (field) -> FormFieldSettings? in
                    let settings = BodyTextFieldSettings(spacingAbove: 0, spacingBelow: 10)
                    return settings
            },
            FormField<Empty>(type: .bodyText, title: "BodyText with background")
                .configure { (field) -> FormFieldSettings? in
                    let settings = BodyTextFieldSettings(spacingAbove: 0, spacingBelow: 10, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), backgroundColor: backgroundColor)
                    return settings
            },
            FormField<Empty>(type: .bodyText, customCellIdentifier: "CustomTextCell", title: "BodyText", descriptionText: "with custom cell and description text"),

            FormField<Double>(identifier: "textField", type: .textField, title: "TextField", isRequired: true, validationRule: "(value != undefined)")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.textFieldValue <~ field.content
                    
                    let settings = TextFieldSettings()
                    settings.keyboardType = .decimalPad
                    return settings
            },
            FormField<Bool>(identifier: "toggleField", type: .toggle, title: "ToggleField")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.toggleFieldValue <~ field.content.map { $0 ?? false }
                    return nil
            },
            FormField<String>(identifier: "pickerField", type: .picker, title: "PickerField")
                .configure { field in
                    let items: [PickerFieldOption] = [.one, .two, .three]
                    let viewModel = GenericPickerViewModel(title: "PickerField", items: items, selectedItem: pickerFieldValue)
                    let settings = PickerFieldSettings(viewModel: viewModel)
                    return settings
            },
            FormField<Double>(identifier: "stepperField", type: .stepper, title: "StepperField", descriptionText: "Use stepper buttons.")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.stepperFieldValue <~ field.content
                    
                    let formatter = NumberFormatter()
                    formatter.allowsFloats = true
                    formatter.maximumFractionDigits = 2
                    
                    let settings = StepperFieldSettings(minimumValue: -1.0, maximumValue: 3.0, stepValue: 0.5, formatterClosure: nil)
                    return settings
            },

            ]
        
        setFields(fields)
        
    }
    
    
}

