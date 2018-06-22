//
//  PickerTextField.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 22.06.18.
//  Copyright © 2018 aaa - all about apps GmbH. All rights reserved.
//

import UIKit

public class PickerTextField: UITextField {

    // Disable clipboard operations. This prevents pasting invalid values into the field.
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
