//
//  ReactiveItem.swift
//  Example
//
//  Created by Gunter Hager on 22.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation
import ReactiveSwift
import DataSource

public class ReactiveItem<T>: Hideable, Diffable, Equatable {
    
    public let diffIdentifier = UUID().uuidString
    
    public func isEqualToDiffable(_ other: Diffable?) -> Bool {
        return self.diffIdentifier == other?.diffIdentifier
    }
    
    public static func ==(lhs: ReactiveItem<T>, rhs: ReactiveItem<T>) -> Bool {
        return lhs.diffIdentifier == rhs.diffIdentifier
    }
    
    public let property = MutableProperty<T?>(nil)
    public let isHidden = MutableProperty(false)
    
    public init(_ defaultValue: T? = nil, isHidden: Bool = false) {
        self.property.value = defaultValue
        self.isHidden.value = isHidden
    }
    
    public func configure(_ configureClosure: (ReactiveItem<T>) -> Void) -> ReactiveItem<T> {
        configureClosure(self)
        return self
    }
    
}
