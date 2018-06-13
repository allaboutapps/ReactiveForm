//
//  FormFieldProtocol.swift
//  
//
//  Created by Gunter Hager on 12/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift
import DataSource

public protocol FormFieldProtocol: Focusable, Hideable {
    
    var title: MutableProperty<String> { get }
    var type: FormFieldType { get }
    var cellIdentifier: String { get }
    var form: Form! { get set }
    var isHidden: MutableProperty<Bool> { get }
    var isEnabled: MutableProperty<Bool> { get }
    var settings: FormFieldSettings? { get set }
    var row: RowType { get }
    
    // Import/Export
    var isExportable: Bool { get }
    func exportContent() -> Any?
    func importContent(_ content: Any?)
    
    // Validation
    var isRequired: Bool { get }
    var validationState: MutableProperty<ValidationState> { get }
    var isValid: Property<Bool> { get }

    /// Validation rules are defined in `JavaScript`. The value of the field is exposed to `JavaScript` as variable named `value`. You could use a rule like `value > 0` to validate the value of your field.
    var validationRule: MutableProperty<String?> { get }
}

extension FormFieldProtocol {
        
    // MARK: - Validation
    
    public func validate(value: Any?) -> ValidationState {
        guard let rule = validationRule.value else { return .success }
        let isValid = Validation.shared.validate(value: value, withRule: rule)
        return isValid ? .success : .error(text: nil)
    }
    
}
