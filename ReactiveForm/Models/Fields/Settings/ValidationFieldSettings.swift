//
//  ValidationFieldSettings.swift
//  
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

public enum ValidationState {
    case success
    case info(text: String?)
    case warning(text: String?)
    case error(text: String?)
}


public class ValidationFieldSettings: FormFieldSettings {
    override public var isExportable: Bool { return true }

    public let displayedState = MutableProperty<ValidationState>(.success)
    public var isInitial = true
}
