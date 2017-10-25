//
//  StepperFieldSettings.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 24.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation

public extension Form {
    
    // Value
    // min, max, step, formatter
    
    public typealias FormatterClosure = ((_ value: Double) -> String?)
    
    public class StepperFieldSettings: FieldSettings {
                
        override public var isExportable: Bool { return true }
        
        public var minValue: Double
        public var maxValue: Double
        public var stepValue: Double
        public var formatterClosure: FormatterClosure?
        
        public init(minValue: Double = -Double.greatestFiniteMagnitude, maxValue: Double = Double.greatestFiniteMagnitude, stepValue: Double = 1.0, formatterClosure: FormatterClosure? = nil) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.stepValue = stepValue
            self.formatterClosure = formatterClosure
        }
        
    }
    
}
