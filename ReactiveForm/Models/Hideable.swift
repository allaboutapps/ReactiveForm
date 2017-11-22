//
//  Hideable.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 22.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol Hideable {
    var isHidden: MutableProperty<Bool> { get }
}
