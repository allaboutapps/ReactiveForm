//
//  PickerFieldSettings.swift
//  
//
//  Created by Gunter Hager on 14/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol GenericPickerViewModelProtocol {
    var items: [PickerItem] { get set }
    var selectedItem: MutableProperty<PickerItem?> { get }
    var title: String { get }
}

public protocol PickerItem: FormFieldContent {
    var title: String { get }
}

public extension Form {
    
    public class PickerFieldSettings: FieldSettings {
        
        override public var isExportable: Bool { return true }

        public var pickerViewModel: GenericPickerViewModelProtocol
        
        public init(viewModel: GenericPickerViewModelProtocol) {
            self.pickerViewModel = viewModel
            super.init()
        }
        
    }
    
}
