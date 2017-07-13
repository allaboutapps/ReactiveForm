//
//  SwitchCell.swift
//  DataSource
//
//  Created by Matthias Buchetics on 28/02/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    var field: Form.SwitchField!
    
    var disposable = CompositeDisposable()
    
    func configure(field: Form.SwitchField) {
        self.field  = field
        
        titleLabel.text = field.title
        onSwitch.isOn = field.isOn.value
        onSwitch.isEnabled = field.isEnabled.value
        
        // Bind field data to UI and vise versa
        disposable += field.isOn <~ onSwitch.reactive.isOnValues
        disposable += onSwitch.reactive.isOn <~ field.isOn
        disposable += onSwitch.reactive.isEnabled <~ field.isEnabled
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }
}

extension SwitchCell {
    
    static var descriptor: CellDescriptor<Form.SwitchField, SwitchCell> {
        return CellDescriptor()
            .configure { (field, cell, indexPath) in
                cell.configure(field: field)
        }
    }
}

