//
//  FormItemProtocol.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 17.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol FormItemProtocol {
    
    var title: MutableProperty<String> { get }
    var type: FormItemType  { get }
    var cellIdentifier: String { get }
    var form: Form! { get set }
    var isHidden: MutableProperty<Bool> { get }
    var settings: FormFieldSettings? { get set }
    
}
