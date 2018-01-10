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

enum NamedNumber: PickerItem {
    case one
    case two
    case three
    
    var title: String {
        switch self {
        case .one: return "One"
        case .two: return "Two"
        case .three: return "Three"
        }
    }
}

class AllFieldsViewController: UIViewController, FormViewController {    
    
    let namedNumber = MutableProperty<NamedNumber?>(nil)
    let segmentedIndex = MutableProperty<Int>(0)
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
        let text1Item = ReactiveItem<String>("First segment selected.")
            .configure { [weak self] (item) in
                guard let `self` = self else { return }
                item.isHidden <~ self.segmentedIndex.map { $0 != 0 }
        }
        let text2Item = ReactiveItem<String>("Second segment selected.")
            .configure { [weak self] (item) in
                guard let `self` = self else { return }
                item.isHidden <~ self.segmentedIndex.map { $0 != 1 }
        }
        let text3Item = ReactiveItem<String>("Third segment selected.")
            .configure { [weak self] (item) in
                guard let `self` = self else { return }
                item.isHidden <~ self.segmentedIndex.map { $0 != 2 }
        }

        let emailField = FormField<String>(identifier: "email",
                                           type: .textField,
                                           title: "Email",
                                           isRequired: true,
                                           validationRule: "(value != undefined) && (value.length >= 3) && value.includes('@')",
                                           validationErrorText: "Invalid email address!")
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
                FormField<Double>(type: .textField, title: "Number Field")
                    .configure({ (field) -> FormFieldSettings? in
                        field.content.producer.startWithValues { (value) in
                            print("Double value: \(String(describing: value))")
                        }
                        
                        let settings = TextFieldSettings()
                        settings.keyboardType = .decimalPad
                        return settings
                    })
                    .row,
                FormField<Bool>(type: .toggle, title: "Toggle Field")
                    .row,
                FormField<String>(identifier: "namedNumber", type: .picker, title: "Choose number")
                    .configure { field in
                        let viewModel = GenericPickerViewModel(title: "Choose number", items: [NamedNumber.one, NamedNumber.two, NamedNumber.three], selectedItem: namedNumber)
                        let settings = PickerFieldSettings(viewModel: viewModel)
                        return settings
                    }
                    .row
                ]).with(identifier: "inputFields"),
            
            Section(rows: [
                FormField<Int>(type: .segmented, title: "segmented")
                    .configure { [weak self] field in
                        guard let `self` = self else { return nil }
                        self.segmentedIndex <~ field.content.map { $0 ?? 0 }
                        let settings = SegmentedFieldSettings(segments: ["One", "Two", "Three"])
                        return settings
                    }
                    .row,
                Row(text1Item, identifier: "TextCell"),
                Row(text2Item, identifier: "TextCell"),
                Row(text3Item, identifier: "TextCell"),

                emailField
                    .configure { [weak self] field in
                        guard let `self` = self else { return nil }
                        self.email <~ field.content
                        field.isHidden <~ self.segmentedIndex.map { $0 != 0 }

                        let settings = TextFieldSettings()
                        settings.textContentType = .emailAddress
                        settings.keyboardType = .emailAddress
                        settings.autocorrectionType = .no
                        return settings
                    }
                    .row,
                emailField.validationField()
                    .row,
                FormField<Bool>(type: .toggle, title: "Tell me more")
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
