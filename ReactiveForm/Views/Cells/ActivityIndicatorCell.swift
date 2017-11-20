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


class ActivityIndicatorCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spacingAboveConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingBelowConstraint: NSLayoutConstraint!

    override func configure<T>(field: FormField<T>) {
        super.configure(field: field)
        guard field.type == .activityIndicator else { return }
        
        if let settings = field.settings as? ActivityIndicatorFieldSettings {
            spacingAboveConstraint.constant = settings.spacingAbove
            spacingBelowConstraint.constant = settings.spacingBelow
            disposable += activityIndicator.reactive.isAnimating <~ settings.isAnimating
        }
    }
    
}

extension ActivityIndicatorCell {
    
    static var descriptor: CellDescriptor<FormField<Empty>, ActivityIndicatorCell> {
        return CellDescriptor("ActivityIndicatorCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


