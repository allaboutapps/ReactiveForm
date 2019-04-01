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

public protocol ReactiveItemProtocol: Hideable {
}

open class ReactiveItem<T>: ReactiveItemProtocol, Diffable, Equatable {
    
    private let internalIdentifier = UUID().uuidString
    
    public var diffIdentifier: String {
        if let diffable = property as? Diffable {
            return diffable.diffIdentifier
        } else {
            return internalIdentifier
        }
    }
    
    public func isEqualToDiffable(_ other: Diffable?) -> Bool {
        if let diffable = property as? Diffable {
            return diffable.isEqualToDiffable(other)
        } else {
            return self.diffIdentifier == other?.diffIdentifier
        }
    }
    
    //swiftlint:disable operator_whitespace
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
