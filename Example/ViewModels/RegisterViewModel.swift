//
//  RegisterViewModel.swift
//  
//
//  Created by Gunter Hager on 11/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift
import ReactiveForm

enum NamePrefix: String, Codable, PickerItem {
    case none
    case female
    case male
    case other
    
    var title: String {
        switch self {
        case .female:           return "Ms."
        case .male:             return "Mr."
        case .none, .other:     return "Other"
        }
    }
}

struct Country: PickerItem, Codable {
    
    let isoCode: String
    
    var title: String {
        return Locale.current.localizedString(forRegionCode: isoCode) ?? isoCode
    }
    
    static var allCountries: [Country] {
        return Locale.isoRegionCodes.map { Country(isoCode: $0) }
    }
    
    static var defaultCountry: Country? {
        guard let code = Locale.current.regionCode else { return nil }
        return Country(isoCode: code)
    }
    
}


class RegisterViewModel: CardViewModel {
    
    let namePrefix = MutableProperty<NamePrefix?>(nil)
    let givenName = MutableProperty<String?>(nil)
    let familyName = MutableProperty<String?>(nil)
    
    let email = MutableProperty<String?>(nil)
    let password = MutableProperty<String?>(nil)
    
    let customerNumber = MutableProperty<String?>(nil)
    let country = MutableProperty<Country?>(Country.defaultCountry)
    
    let privacyAccepted = MutableProperty<Bool>(false)
    let tosAccepted = MutableProperty<Bool>(false)
        
    // MARK: - Lifecycle
    
    override init() {
        
        super.init()
        
        primaryActionSettings.value = ActionButtonSettings(title: "Register", action: { [weak self] (viewModel, controller) in
//            self?.register(controller: controller)
        })
        
        let emailField = Form.Field<String>(identifier: "email", type: .textField, title: "Email", isRequired: true, validationRule: "(value.length >= 3) && value.includes('@')", validationErrorText: "Invalid email")
        
        let passwordField = Form.Field<String>(identifier: "password", type: .textField, title: "Password", isRequired: true, validationRule: "value.length >= 6", validationErrorText: "Invalid password")
        
        let customerNumberField = Form.Field<String>(identifier: "customerNumber", type: .textField, title: "Customer number", isRequired: true, validationRule: "value.length >= 2", validationErrorText: "Invalid customer number")
        
        setFields([
            Form.Field<Empty>(type: .title, title: "Register"),
            Form.Field<String>(identifier: "namePrefix", type: .picker, title: "Name prefix")
                .configure { field in
                    let viewModel = GenericPickerViewModel(title: "Name prefix", items: [NamePrefix.female, NamePrefix.male, NamePrefix.other], selectedItem: namePrefix)
                    let settings = Form.PickerFieldSettings(viewModel: viewModel)                    
                    return settings
            },
            Form.Field<String>(identifier: "givenName", type: .textField, title: "Given name")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.givenName <~ field.content
                    
                    let settings = Form.TextFieldSettings()
                    settings.textContentType = .givenName
                    return settings
            },
            Form.Field<String>(identifier: "familyName", type: .textField, title: "Family name")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.familyName <~ field.content
                    
                    let settings = Form.TextFieldSettings()
                    settings.textContentType = .familyName
                    return settings
            },
            emailField
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.email <~ field.content
                    
                    let settings = Form.TextFieldSettings()
                    settings.textContentType = .emailAddress
                    settings.keyboardType = .emailAddress
                    settings.autocorrectionType = .no
                    return settings
            },
            emailField.validationField(),
            passwordField
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.password <~ field.content
                    
                    let settings = Form.TextFieldSettings()
                    settings.isSecureTextEntry = true
                    return settings
            },
            passwordField.validationField(),
            customerNumberField
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.customerNumber <~ field.content
                    
                    let settings = Form.TextFieldSettings()
                    return settings
            },
            customerNumberField.validationField(),
            Form.Field<String>(identifier: "country", type: .picker, title: "Country", isRequired: true)
                .configure { field in
                    let viewModel = GenericPickerViewModel(title: "Country", items: Country.allCountries, selectedItem: country)
                    let settings = Form.PickerFieldSettings(viewModel: viewModel)
                    return settings
            },
            Form.Field<CGFloat>(type: .spacer, title: "Spacer", content: 8),
            Form.Field<Bool>(identifier: "privacyAccepted", type: .toggle, title: "Privacy", isRequired: true, validationRule: "value == true")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.privacyAccepted <~ field.content.map { $0 ?? false }
                    let settings = Form.ToggleFieldSettings()
                    settings.link = {
                        let controller: EmptyViewController = UIStoryboard(.main).instantiateViewController()
                        self.viewController?.show(controller, sender: self)
                    }
                    return settings
            },
            Form.Field<Bool>(identifier: "tosAccepted", type: .toggle, title: "Terms of service", isRequired: true, validationRule: "value == true")
                .configure { [weak self] field in
                    guard let `self` = self else { return nil }
                    self.tosAccepted <~ field.content.map { $0 ?? false }
                    let settings = Form.ToggleFieldSettings()
                    settings.link = {
                        let controller: EmptyViewController = UIStoryboard(.main).instantiateViewController()
                        self.viewController?.show(controller, sender: self)
                    }
                    return settings
            },
            ])
        
        form.returnKey = .join
        
        bind()
    }
    
    private func bind() {
        primaryActionIsEnabled <~ form.isValid
    }
    
    
}


