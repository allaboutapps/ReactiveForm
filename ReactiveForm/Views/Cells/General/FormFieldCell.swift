//
//  FormFieldCell.swift
//  
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

open class FormFieldCell: UITableViewCell {
    open var field: FormFieldProtocol!
    open var disposable = CompositeDisposable()
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }

    open func configure<T>(field: FormField<T>) {
        self.field = field
    }

}
