//
//  GenericPickerViewModel.swift
//
//
//  Created by Gunter Hager on 13/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift

public class GenericPickerViewModel<T: PickerItem>: GenericPickerViewModelProtocol {

    public var title: String
    public var cancelButtonTitle: String
    public var submitButtonTitle: String
    public var selectedItem = MutableProperty<PickerItem?>(nil)
    public var items: [PickerItem]
    
    private weak var privateSelectedItem: MutableProperty<T?>?
    
    public init(title: String, cancelButtonTitle: String, submitButtonTitle: String, items: [T], selectedItem: MutableProperty<T?>) {
        self.title = title
        self.cancelButtonTitle = cancelButtonTitle
        self.submitButtonTitle = submitButtonTitle
        self.items = items
        self.privateSelectedItem = selectedItem
        if let privateSelectedItem = privateSelectedItem {
            self.selectedItem.value = privateSelectedItem.value
            privateSelectedItem <~ self.selectedItem.map { $0 as? T }
        }
    }

}
