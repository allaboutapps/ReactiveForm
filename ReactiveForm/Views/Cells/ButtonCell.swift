//
//  ButtonCell.swift
//  
//
//  Created by Gunter Hager on 08/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveCocoa
import ReactiveSwift

class ButtonCell: ReactiveFormFieldCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var roundedButton: DesignableButton!

    override func configure<T>(field: FormField<T>) {
        super.configure(field: field)
        guard field.type == .button else { return }
        
        if let settings = field.settings as? ButtonFieldSettings {
            let appearance = settings.appearance ?? .text
            switch appearance {
            case .rounded:
                button.isHidden = true
                roundedButton.isHidden = false
                if let tint = settings.tintColor {
                    roundedButton.setBackgroundColor(tint, for: .normal, animated: false, animationDuration: nil)
                }
                disposable += roundedButton.reactive.title(for: .normal) <~ field.title.map { $0.localizedUppercase }
            default:
                button.isHidden = false
                roundedButton.isHidden = true
                button.tintColor = settings.tintColor
                button.contentHorizontalAlignment = settings.alignment
                disposable += button.reactive.title(for: .normal) <~ field.title
            }
        }
        disposable += button.reactive.isEnabled <~ field.isEnabled
    }
    
    @IBAction func execute(_ sender: Any) {
        guard let settings = field.settings as? ButtonFieldSettings else { return }
        settings.action?(field)
    }
}

extension ButtonCell {
    
    static var descriptor: CellDescriptor<FormField<Empty>, ButtonCell> {
        return CellDescriptor("ButtonCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}



