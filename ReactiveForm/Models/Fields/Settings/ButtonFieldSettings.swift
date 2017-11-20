//
//  ButtonFieldSettings.swift
//  
//
//  Created by Gunter Hager on 08/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit


public enum ButtonAppearance {
    case text
    case rounded
}

public class ButtonFieldSettings: FormFieldSettings {
    
    public var appearance: ButtonAppearance? = nil
    public var backgroundColor: UIColor? = nil
    public var tintColor: UIColor? = nil
    public var alignment: UIControlContentHorizontalAlignment = .center
    public var action: ((FormFieldProtocol) -> Void)?
    
}
