//
//  AllFieldsViewController.swift
//  Example
//
//  Created by Gunter Hager on 21.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import ReactiveForm
import ReactiveSwift

class AllFieldsViewController: UIViewController, FormViewController {    
    
    let email = MutableProperty<String?>(nil)
    let tellMeMore = MutableProperty<Bool>(false)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var form = Form(cellDescriptors: [
        CellDescriptor<ReactiveItem<String>, UITableViewCell>("TextCell", cellIdentifier: "TextCell")
            .configure { (item, cell, _) in
                cell.textLabel?.text = item.property.value
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
        ],
                    sectionDescriptors: [
                        SectionDescriptor<Void>("inputFields")
                            .header { .title("Input fields") }
                            .footer { .title("Try them all!") }
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form.viewController = self
        bind()
        setupForm()
        form.dataSource.reloadData(tableView, animated: false)
    }
    
    private func bind() {
        
        tableView.delegate = form.dataSource
        tableView.dataSource = form.dataSource
        
        Keyboard.shared.heightInfo.producer.startWithValues { [weak self] heightInfo in
            guard let `self` = self else { return }
            self.tableViewBottomConstraint.constant = -heightInfo.keyboardHeight
            UIView.animate(withDuration: heightInfo.animationDuration, delay: 0.0, options: heightInfo.animationOptions, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    private func setupForm() {
        let emailField = FormField<String>(identifier: "email",
                                           type: .textField,
                                           title: "Email",
                                           isRequired: true,
                                           validationRule: "(value != undefined) && (value.length >= 3) && value.includes('@')",
                                           validationErrorText: "Invalid email address!")
        let tellMeMoreField = FormField<Bool>(type: .toggle, title: "Tell me more")
        let tellMeMoreItem = ReactiveItem<String>("Here is where we get more information about life, the universe and everything.")
            .configure { [weak self] (item) in
                guard let `self` = self else { return }
                item.isHidden <~ self.tellMeMore.map { !$0 }
        }
        
        form.setSections(sections: [
            Section(rows: [
                Row(ReactiveItem<String>("Hello world!"), identifier: "TextCell"),
                FormField<String>(type: .textField, title: "Text Field")
                    .row,
                FormField<Bool>(type: .toggle, title: "Toggle Field")
                    .row
                ]).with(identifier: "inputFields"),
            Section(rows: [
                emailField
                    .configure { [weak self] field in
                        guard let `self` = self else { return nil }
                        self.email <~ field.content
                        
                        let settings = TextFieldSettings()
                        settings.textContentType = .emailAddress
                        settings.keyboardType = .emailAddress
                        settings.autocorrectionType = .no
                        return settings
                    }
                    .row,
                emailField.validationField()
                    .row,
                tellMeMoreField
                    .configure { [weak self] field in
                        guard let `self` = self else { return nil }
                        self.tellMeMore <~ field.content.map { $0 ?? false }
                        return nil
                    }
                    .row,
                Row(tellMeMoreItem, identifier: "TextCell")
                ])
            ])
    }
    
}
