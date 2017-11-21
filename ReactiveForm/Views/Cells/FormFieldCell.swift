//
//  FormFieldCell.swift
//  
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

class FormFieldCell: UITableViewCell {
    var field: FormFieldProtocol!
    var disposable = CompositeDisposable()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }

    func configure<T>(field: FormField<T>) {
        self.field = field
    }

}


