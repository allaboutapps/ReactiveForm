//
//  PickerFieldSettings.swift
//  
//
//  Created by Gunter Hager on 14/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol PickerViewModelProtocol {
    var items: [PickerItem] { get set }
    var selectedItem: MutableProperty<PickerItem?> { get }
    var title: String { get }
    var cancelButtonTitle: String { get }
    var submitButtonTitle: String { get }
}

public protocol PickerItem: FormFieldContent {
    var title: String { get }
}

public class PickerFieldSettings: FormFieldSettings {
        
    public var pickerViewModel: PickerViewModelProtocol
    
    public init(viewModel: PickerViewModelProtocol) {
        self.pickerViewModel = viewModel
        super.init()
    }
    
}
