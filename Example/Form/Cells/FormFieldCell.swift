//
//  FormFieldCell.swift
//  
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveForm

class FormFieldCell: UITableViewCell {
    var field: FormFieldProtocol!
    
    func configure<T>(field: Form.Field<T>) {
        self.field = field
    }

}


