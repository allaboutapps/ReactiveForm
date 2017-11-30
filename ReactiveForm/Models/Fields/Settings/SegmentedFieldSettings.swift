//
//  SegmentedFieldSettings.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 30.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation

public class SegmentedFieldSettings: FormFieldSettings {
    
    override public var isExportable: Bool { return true }
    
    public var segments: [String]
    
    public init(segments: [String]) {
        self.segments = segments
    }
    
}
