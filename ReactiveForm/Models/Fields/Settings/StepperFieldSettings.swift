//
//  StepperFieldSettings.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 24.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation

public typealias FormatterClosure = ((_ value: Double) -> String?)

public class StepperFieldSettings: FormFieldSettings {
        
    public var minimumValue: Double
    public var maximumValue: Double
    public var stepValue: Double
    public var formatterClosure: FormatterClosure?
    
    public init(minimumValue: Double = -Double.greatestFiniteMagnitude, maximumValue: Double = Double.greatestFiniteMagnitude, stepValue: Double = 1.0, formatterClosure: FormatterClosure? = nil) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.stepValue = stepValue
        self.formatterClosure = formatterClosure
    }
    
}
