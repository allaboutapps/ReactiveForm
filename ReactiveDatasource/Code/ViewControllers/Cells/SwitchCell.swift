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

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    var field: Form.SwitchField!
    
    func configure(field: Form.SwitchField) {
        self.field  = field
        
        titleLabel.text = field.title
        onSwitch.isOn = field.isOn.value
        
        field.isOn <~ onSwitch.reactive.isOnValues
        onSwitch.reactive.isOn <~ field.isOn
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

