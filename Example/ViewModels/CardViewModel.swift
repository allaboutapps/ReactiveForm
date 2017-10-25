//
//  CardViewModel.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

typealias ActionClosure = ((CardViewModel, UIViewController) -> Void)

struct ActionButtonSettings {
    let title: String
    let action: ActionClosure
}

class CardViewModel {
    
    let form = Form()
    
    var tintColor: UIColor?
    
    weak var viewController: CardViewController?
    
    func setFields(_ fields: [FormFieldProtocol]) {
        let rows = fields.map { Row($0, identifier: $0.cellIdentifier) }
        dataSource.sections = [Section(rows: rows)]
        form.sections = dataSource.sections
        form.onSubmit = { [weak self] (data, sender) in
            guard let `self` = self,
                let viewController = self.viewController else { return }
            if !self.form.isValid.value {
                Toast.shared.show("Invalid form input", level: .error)
            }
            self.primaryActionSettings.value?.action(self, viewController)
        }
        
        form.didChange = { [weak self] in
            guard let `self` = self,
                let tableView = self.viewController?.tableView
                else { return }
            
            self.dataSource.reloadDataAnimated(tableView,
                                               rowDeletionAnimation: .automatic,
                                               rowInsertionAnimation: .automatic,
                                               rowReloadAnimation: .none)
        }
        
        form.setup()
    }
    
    lazy var dataSource: DataSource = {
        let  cellDescriptors: [CellDescriptorType] = [
            TitleCell.descriptor,
            BodyTextCell.descriptor,
            ImageCell.descriptor,
            PickerCell.descriptor
                .didSelect { (item, _) in
                    if let settings = item.settings as? Form.PickerFieldSettings {
                        let picker: GenericPickerViewController = UIStoryboard(.form).instantiateViewController()
                        picker.viewModel = settings.pickerViewModel
                        self.viewController?.present(picker, animated: true)
                    }
                    return .deselect
                },
            StepperCell.descriptor,
            ButtonCell.descriptor,
            ToggleCell.descriptor,
            ActivityIndicatorCell.descriptor,
            SpacerCell.descriptor,
            ValidationCell.descriptor
        ]
            + TextFieldCell.descriptors
        
        return DataSource(
            cellDescriptors: cellDescriptors,
            sectionDescriptors: [
                SectionDescriptor<Void>()
                    .headerHeight { return .zero }
                    .footerHeight { return .zero }
            ],
            registerNibs: true
        )
    }()
    
    // MARK: - Lifecycle
    
    func viewDidAppear() {
        // Can be implemented in subclasses.
    }
    
    // MARK: - Action buttons
    
    /// If set, a primary action button will be shown.
    let primaryActionSettings = MutableProperty<ActionButtonSettings?>(nil)
    let primaryActionIsEnabled = MutableProperty<Bool>(true)
    
    func primaryAction(viewController: UIViewController) {
        if !form.isValid.value {
            Toast.shared.show("Invalid form input", level: .error)
        }
        primaryActionSettings.value?.action(self, viewController)
    }
    
    /// If set, a secondary action button will be shown.
    let secondaryActionSettings = MutableProperty<ActionButtonSettings?>(nil)
    let secondaryActionIsEnabled = MutableProperty<Bool>(true)
    
    func secondaryAction(viewController: UIViewController) {
        secondaryActionSettings.value?.action(self, viewController)
    }
    
}
