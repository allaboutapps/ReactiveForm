//
//  RegistrationViewController.swift
//  ReactiveForm
//
//  Created by Michael Heinzl on 12.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa
import ReactiveForm

class RegistrationViewController: UITableViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var thumbsUpLabel: UILabel!
    
    let form = Form()
    
    lazy var nameField: Form.TextField = {
        Form.TextField(id: "name", form: self.form, placeholder: "Name",
                       textInputTraits: TextInputTraits.defaultNameTraits,
                       bindings: { (field) in
                        field.validationState <~ field.text.producer.map { (text) in
                            if let text = text {
                                if text.characters.count <= 1  {
                                    return .info(text: "2 - 25 letters")
                                } else if text.characters.count > 25 {
                                    return .info(text: "2 - 25 letters")
                                }
                            }
                            
                            return .success
                        }
                        
        })
    }()
    
    lazy var emailField: Form.TextField = {
        Form.TextField(id: "email", form: self.form, placeholder: "E-Mail",
                       textInputTraits: TextInputTraits.create({
                        $0.keyboardType = .emailAddress
                        $0.autocapitalizationType = .none
                        $0.autocorrectionType = .no
                        $0.spellCheckingType = .no
                       }),
                       bindings: { (field) in
                        field.validationState <~ field.text.producer.map { (text) in
                            if let text = text {
                                guard text.contains("@") else { return .info(text: "Enter valid Email") }
                            }
                            
                            return .success
                        }
        }
        )
    }()
    
    lazy var birthdateField: Form.DateField = {
        Form.DateField(id: "birthdate", form: self.form)
    }()
    
    lazy var newsletterField: Form.SwitchField = {
        Form.SwitchField(id: "newsletterSwitch", form: self.form, title: "Newsletter",
            bindings: { (field) in
                field.isOn.signal.observeValues { (value) in
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
                        self.thumbsUpLabel.frame = self.thumbsUpLabel.frame.offsetBy(dx: value ? -100 : 100, dy: 0)
                    }, completion: nil)
                }
            }
        )
    }()
    
    lazy var passwordField: Form.TextField = {
        Form.TextField(id: "password", form: self.form, placeholder: "Password",
                       textInputTraits: TextInputTraits.create({
                        $0.isSecureTextEntry = true
                       }),
                       bindings: { (field) in
                        field.validationState <~ field.text.producer.map { (text) in
                            if let text = text {
                                guard text.characters.count > 1 else {
                                    return .error(text: "too short")
                                }
                                guard text.rangeOfCharacter(from: .decimalDigits) != nil else {
                                    return .error(text: "musst contain digit")
                                }
                            }
                            
                            return .success
                        }
        }
        )
    }()
    
    lazy var passwordConfirmationField: Form.TextField = {
        Form.TextField(id: "passwordConfirmation", form: self.form, placeholder: "Confirmation",
                       textInputTraits: TextInputTraits.create({
                        $0.isSecureTextEntry = true
                       }),
                       bindings: { (field) in
                        field.validationState <~ field.text.producer.map { (text) in
                            if let text = text {
                                guard text == self.passwordField.text.value else {
                                    return .error(text: "passwords not equal")
                                }
                            }
                            
                            return .success
                        }
        }
        )
    }()
    
    lazy var dataSource: DataSource = {
        DataSource(
            cellDescriptors: [
                TextFieldCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                    }
                    .willSelect { nil },
                SwitchCell.descriptor
                    .willSelect { nil },
                ValidationCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                    }
                    .willSelect { nil },
                ExternalDateCell.descriptor
            ],
            sectionDescriptors: [
                SectionDescriptor<Void>("section-user")
                    .header {
                        .none
                },
                
                SectionDescriptor<Void>("section-password")
                    .header {
                        .none
                },
            ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbsUpLabel.frame = thumbsUpLabel.frame.offsetBy(dx: 100, dy: 0)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        dataSource.sections = [
            Section(items: [
                nameField,
                nameField.validationField(),
                emailField,
                emailField.validationField(),
                birthdateField,
                newsletterField
                ]).with(identifier: "section-user"),
            
            Section(items: [
                passwordField,
                passwordField.validationField(),
                passwordConfirmationField,
                passwordConfirmationField.validationField()
                ]).with(identifier: "section-password"),
        ]
        
        form.didChange = {
            self.reloadUI()
        }
        
        form.onSubmit = { (data) in
            print("Form was submitted:", data)
            
        }
        
        form.sections = dataSource.sections
        form.setup()
        
        dataSource.reloadData(tableView, animated: false)

    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        form.submit()
    }
    
    func reloadUI() {
        dataSource.reloadData(tableView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showBirthdatePicker":
            guard let controller = segue.destination as? DateViewController else { return }
            guard let cell = sender as? ExternalDateCell else { return }
            
            controller.field = cell.field
        default:
            break
        }
    }
    
}
