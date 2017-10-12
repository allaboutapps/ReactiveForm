//
//  ActivityIndicatorCell.swift
//  
//
//  Created by Gunter Hager on 06/10/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveCocoa
import ReactiveSwift
import ReactiveForm


class ActivityIndicatorCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spacingAboveConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingBelowConstraint: NSLayoutConstraint!

    override func configure<T>(field: Form.Field<T>) {
        super.configure(field: field)
        guard field.type == .activityIndicator else { return }
        
        if let settings = field.settings as? Form.ActivityIndicatorFieldSettings {
            spacingAboveConstraint.constant = settings.spacingAbove
            spacingBelowConstraint.constant = settings.spacingBelow
            disposable += activityIndicator.reactive.isAnimating <~ settings.isAnimating
        }
    }
    
}

extension ActivityIndicatorCell {
    
    static var descriptor: CellDescriptor<Form.Field<Empty>, ActivityIndicatorCell> {
        return CellDescriptor("ActivityIndicatorCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


