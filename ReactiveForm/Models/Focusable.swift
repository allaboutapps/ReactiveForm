//
//  Focusable.swift
//  
//
//  Created by Michael Heinzl on 10.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

public protocol Focusable {
    var identifier: String { get }
    var isFocusable: Bool { get }
    var configureReturnKey: (() -> Void)? { get set }
    var focus: (() -> Void)? { get set }
    var nextFocusableField: Focusable? { get }
    var previousFocusableField: Focusable? { get }
}

public extension Focusable where Self: FormFieldProtocol {
    
    public var focusableIndex: Int {
        guard let index = form.focusableFields.index(where: { self.identifier == $0.identifier }) else {
            fatalError("Field not found in form.")
        }
        return index
    }
    
    public var nextFocusableField: Focusable? {
        let nextIndex = focusableIndex + 1
        guard nextIndex < form.focusableFields.count else { return nil }
        return form.focusableFields[nextIndex]
    }
    
    public var previousFocusableField: Focusable? {
        let nextIndex = focusableIndex - 1
        guard nextIndex >= 0 else { return nil }
        return form.focusableFields[nextIndex]
    }
    
    public var isLastFocuFocusableField: Bool {
        return nextFocusableField == nil
    }
}

public extension Form {
    public var focusableFields: [Focusable] {
        return fields
            .filter {
                return ($0.isHidden.value == false)
                    && $0.isEnabled.value
                    && $0.isFocusable
        }
    }
}
