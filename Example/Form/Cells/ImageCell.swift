//
//  ImageCell.swift
//  
//
//  Created by Gunter Hager on 26/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveCocoa
import ReactiveSwift
import ReactiveForm

class ImageCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var spacingAboveConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingBelowConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContentView: UIImageView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    var imageAspectConstraint: NSLayoutConstraint?
    
    override func configure<T>(field: Form.Field<T>) {
        super.configure(field: field)
        guard field.type == .image else { return }
                
        if let settings = field.settings as? Form.ImageFieldSettings {
            spacingAboveConstraint.constant = settings.spacingAbove
            spacingBelowConstraint.constant = settings.spacingBelow
            
            disposable += imageContentView.reactive.image <~ settings.image
            disposable += settings.image.producer.startWithValues { [weak self] (image) in
                guard let `self` = self else { return }
                guard let image = image else { return }
                
                self.imageWidthConstraint.constant = settings.width
                
                // Remove old constraint if present (when reusing cell)
                self.imageAspectConstraint?.isActive = false
                let aspectRatio = image.size.height / image.size.width 
                self.imageAspectConstraint = self.imageContentView.heightAnchor.constraint(equalTo: self.imageContentView.widthAnchor, multiplier: aspectRatio)
                self.imageAspectConstraint?.isActive = true
            }
        }
    }
    
}

extension ImageCell {
    
    static var descriptor: CellDescriptor<Form.Field<Empty>, ImageCell> {
        return CellDescriptor("ImageCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}



