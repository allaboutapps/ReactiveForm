//
//  SliderFieldSettings.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 08.04.19.
//  Copyright © 2019 aaa - all about apps GmbH. All rights reserved.
//

import Foundation

open class SliderFieldSettings: FormFieldSettings {
    
    public var minimumValue: Double
    public var maximumValue: Double
    public var formatterClosure: FormatterClosure?
    
    public init(minimumValue: Double = -Double.greatestFiniteMagnitude, maximumValue: Double = Double.greatestFiniteMagnitude, formatterClosure: FormatterClosure? = nil) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.formatterClosure = formatterClosure
    }
    
}
