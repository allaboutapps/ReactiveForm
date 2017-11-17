//
//  BodyTextCell.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveCocoa
import ReactiveSwift
import ReactiveForm

class BodyTextCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var spacingAboveConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingBelowConstraint: NSLayoutConstraint!
    @IBOutlet weak var padTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var padBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var padLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var padRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel?

    @IBOutlet weak var backgroundColorView: UIView!
    
    override func configure<T>(field: Form.Field<T>) {
        super.configure(field: field)
        guard field.type == .bodyText else { return }
        disposable += titleLabel.reactive.text <~ field.title
        if let descriptionLabel = descriptionLabel {
            disposable += descriptionLabel.reactive.text <~ field.descriptionText
        }

        iconView.isHidden = true
        
        if let settings = field.settings as? Form.BodyTextFieldSettings {
            spacingAboveConstraint.constant = settings.spacingAbove
            spacingBelowConstraint.constant = settings.spacingBelow
            
            padTopConstraint.constant = settings.padding.top
            padLeftConstraint.constant = settings.padding.left
            padBottomConstraint.constant = settings.padding.bottom
            padRightConstraint.constant = settings.padding.right
            
            titleLabel.font = settings.font
            disposable += titleLabel.reactive.textColor <~ settings.textColor.map { $0 ?? .black }
            disposable += iconView.reactive.isHidden <~ settings.icon.map { $0 == nil }
            disposable += iconView.reactive.image <~ settings.icon
            disposable += backgroundColorView.reactive.backgroundColor <~ settings.backgroundColor.map { $0 ?? .clear }
        }
    }
    
}

extension BodyTextCell {
    
    static var descriptor: CellDescriptor<Form.Field<Empty>, BodyTextCell> {
        return CellDescriptor("BodyTextCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}


