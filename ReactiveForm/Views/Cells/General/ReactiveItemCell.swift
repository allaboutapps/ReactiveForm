//
//  ReactiveItemCell.swift
//  
//
//  Created by Gunter Hager on 22.11.17.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift

open class ReactiveItemCell: UITableViewCell {
    open var item: ReactiveItemProtocol!
    open var disposable = CompositeDisposable()
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }
    
    open func configure<T>(item: ReactiveItem<T>) {
        self.item = item
    }

}
