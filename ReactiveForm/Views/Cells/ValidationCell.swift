//
//  ValidationCell.swift
//  
//
//  Created by Gunter Hager on 19/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift

public class ValidationCell: FormFieldCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    
    override public func configure<T>(field: FormField<T>) {
        super.configure(field: field)
        guard field.type == .validation else { return }
        guard let settings = field.settings as? ValidationFieldSettings else { return }
        
        disposable += settings.displayedState.producer.startWithValues { [weak self] state in
            guard let `self` = self else { return }
            var text = field.validationErrorText
            switch state {
            case let .info(message):
                text = message ?? text
            case let .warning(message):
                text = message ?? text
            case let .error(message):
                text = message ?? text
            default:
                break
            }
            self.titleLabel.text = text
        }
    }
    
}

public extension ValidationCell {
    
    public static var descriptor: CellDescriptor<FormField<Empty>, ValidationCell> {
        return CellDescriptor("ValidationCell", bundle: Bundle(for: ValidationCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
