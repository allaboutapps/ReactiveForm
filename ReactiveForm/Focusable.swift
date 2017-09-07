//
//  Focusable.swift
//  ReactiveForm
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
    var configureReturnKey: (() -> Void)? { get set }
    var focus: (() -> Void)? { get set }
    var nextFocusableField: Focusable? { get }
    var previousFocusableField: Focusable? { get }
}

extension Focusable where Self: Form.Field {
    
    public var focusableIndex: Int {
        let _myIndex =  form.focusableFields.index { self.identifier == $0.identifier }
        guard let myIndex = _myIndex else { fatalError() } // Field not found in form
        return myIndex
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

extension Form {
    public var focusableFields: [Focusable] {
        let x = fields.filter { $0.isHidden.value == false && $0.isEnabled.value }
            .flatMap{ $0 as? Focusable }
        return x
    }
}

