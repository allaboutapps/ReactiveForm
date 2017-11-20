//
//  ToggleFieldSettings.swift
//  
//
//  Created by Gunter Hager on 14/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation

public class ToggleFieldSettings: FormFieldSettings {
    
    override public var isExportable: Bool { return true }
    
    public var link: (() -> Void)?
    
    public init(link: (() -> Void)? = nil) {
        self.link = link
    }
    
}

