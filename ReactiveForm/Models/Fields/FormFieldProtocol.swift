//
//  FormFieldProtocol.swift
//  
//
//  Created by Gunter Hager on 12/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol FormFieldProtocol: Focusable {
    
    var title: MutableProperty<String> { get }
    var type: Form.FieldType  { get }
    var cellIdentifier: String { get }
    var form: Form! { get set }
    var isHidden: MutableProperty<Bool> { get }
    var isEnabled: MutableProperty<Bool> { get }
    var settings: Form.FieldSettings? { get set }
    
    // Import/Export
    var isExportable: Bool { get }
    func exportContent() -> Any?
    func importContent(_ content: Any?)
    
    // Validation
    var isRequired: Bool { get }
    var validationState: MutableProperty<Form.ValidationState> { get }
    var isValid: Property<Bool> { get }

    /// Validation rules are defined in `JavaScript`. The value of the field is exposed to `JavaScript` as variable named `value`. You could use a rule like `value > 0` to validate the value of your field.
    var validationRule: String? { get set }
}

extension FormFieldProtocol {
    
    
    // MARK: - Validation
    
    public func validate(value: Any?) -> Form.ValidationState {
        guard let rule = validationRule else { return .success }
        let isValid = Validation.shared.validate(value: value, withRule: rule)
        return isValid ? .success : .error(text: nil)
    }
    

}
