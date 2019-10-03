//
//  ValidationFieldSettings.swift
//  
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift
import ReactiveCocoa

public enum ValidationState: FormFieldContent {
    case success
    case info(text: String?)
    case warning(text: String?)
    case error(text: String?)
}

open class ValidationFieldSettings: FormFieldSettings {
    override open var isExportable: Bool { return true }

    public var isInitial = true
}
