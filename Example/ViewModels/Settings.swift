//
//  Settings.swift
//  Example
//
//  Created by Gunter Hager on 23.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveForm

class SettingsViewModel: CardViewModel {
    
    let waterHardness = MutableProperty<Double?>(nil)
    let waterTreatment = MutableProperty(false)
    let waterTreatmentValue = MutableProperty<Double?>(nil)
    
    let machineGlassware = MutableProperty(false)
    let machinePottery = MutableProperty(false)
    let machinePlastic = MutableProperty(false)
    let machineMetal = MutableProperty(false)
    
    override init() {
        super.init()
        
        tintColor = #colorLiteral(red: 0.6156862745, green: 0.7803921569, blue: 0.2392156863, alpha: 1)
        let backgroundColor: UIColor = #colorLiteral(red: 0.8690528274, green: 0.8690528274, blue: 0.8690528274, alpha: 1)
        
        primaryActionSettings.value = ActionButtonSettings(title: "Einstellungen speichern", action: { (viewModel, controller) in
            Toast.shared.show("Einstellungen wurden gespeichert.")
        })

        let waterTreatmentField = FormField<Bool>(identifier: "waterTreatment", type: .toggle, title: "Wasseraufbereitung vorhanden")
            .configure { [weak self] field in
                guard let `self` = self else { return nil }
                self.waterTreatment <~ field.content.map { $0 ?? false }
                return nil
        }
        
        let fields: [FormFieldProtocol] = [
            FormField<Empty>(type: .title, title: "Einstellungen"),
            
            FormField<Empty>(type: .bodyText, title: "Wasserhärte")
                .configure { (field) -> FormFieldSettings? in
                    let settings = BodyTextFieldSettings(spacingAbove: 0, spacingBelow: 0, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), backgroundColor: backgroundColor)
                    return settings
            },
            FormField<Double>(identifier: "waterHardness", type: .textField, title: "Wasserhärte", isRequired: true, validationRule: "(value != undefined)")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.waterHardness <~ field.content
                    
                    let settings = TextFieldSettings()
                    settings.keyboardType = .decimalPad
                    return settings
            },
            
            
            FormField<Empty>(type: .bodyText, title: "Wasseraufbereitung")
                .configure { (field) -> FormFieldSettings? in
                    let settings = BodyTextFieldSettings(spacingAbove: 20, spacingBelow: 0, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), backgroundColor: backgroundColor)
                    return settings
            },
            waterTreatmentField,
            FormField<Double>(identifier: "waterTreatmentValue", type: .textField, title: "{Durchflussmenge (Liter/Sekunde)}")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    field.isHidden <~ self.waterTreatment.map { !$0 }
                    self.waterTreatmentValue <~ field.content
                    
                    let settings = TextFieldSettings()
                    settings.keyboardType = .decimalPad
                    return settings
            },
            
            FormField<Empty>(type: .bodyText, title: "Spülgut (Mehrfachauswahl möglich)")
                .configure { (field) -> FormFieldSettings? in
                    let settings = BodyTextFieldSettings(spacingAbove: 20, spacingBelow: 0, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), backgroundColor: backgroundColor)
                    return settings
            },
            FormField<Bool>(identifier: "machineGlassware", type: .toggle, title: "Gläser")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.machineGlassware <~ field.content.map { $0 ?? false }
                    return nil
            },
            FormField<Bool>(identifier: "machinePottery", type: .toggle, title: "Keramik")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.machinePottery <~ field.content.map { $0 ?? false }
                    return nil
            },
            FormField<Bool>(identifier: "machinePlastic", type: .toggle, title: "Plastik")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.machinePlastic <~ field.content.map { $0 ?? false }
                    return nil
            },
            FormField<Bool>(identifier: "machineMetal", type: .toggle, title: "Metall")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.machineMetal <~ field.content.map { $0 ?? false }
                    return nil
            },
            
            ]
        
        setFields(fields)
        
        form.validationRule = "form['machineGlassware'] || form['machinePottery'] || form['machinePlastic'] || form['machineMetal']"
        
        primaryActionIsEnabled <~ form.isValid
    }
    
    
}

