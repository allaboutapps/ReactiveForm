//
//  TitleCell.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveCocoa
import ReactiveSwift

class TitleCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var spacingAboveConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingBelowConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func configure<T>(field: FormField<T>) {
        super.configure(field: field)
        guard field.type == .title else { return }
        disposable += titleLabel.reactive.text <~ field.title
        
        if let settings = field.settings as? TitleFieldSettings {
            spacingAboveConstraint.constant = settings.spacingAbove
            spacingBelowConstraint.constant = settings.spacingBelow
            titleLabel.font = settings.font
        }
    }
    
}

extension TitleCell {
    
    static var descriptor: CellDescriptor<FormField<Empty>, TitleCell> {
        return CellDescriptor("TitleCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


