//
//  ValidationField.swift
//  ReactiveForm
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

extension Form {
    public class ValidationField: Form.Field {
        public let displayedState = MutableProperty<ValidationState>(.success)
    }
}

extension Section {
    func fields() -> [Form.Field] {
        var fieldsFromSection: [Form.Field] = []
        for row in self.rows {
            if let field = row.item as? Form.Field {
                fieldsFromSection += [field]
            }
        }
        return fieldsFromSection
    }
}

extension Form.Field {
    
    public func validationField() -> Form.ValidationField {
        let validationField = Form.ValidationField(id: self.identifier + ".validation")
        
        SignalProducer.combineLatest(validationState.producer, isHidden.producer)
            .startWithValues { (value) in
                let validationState = value.0
                let isHidden = value.1
                
                validationField.displayedState.value = validationState
                
                
                if isHidden {
                    // Hide validation field if dependent field is hidden
                    validationField.isHidden.value = true
                } else {
                    // if dependent field is visible, hide validation field if state is success
                    switch validationState {
                    case .success:
                        validationField.isHidden.value = true
                    default:
                        validationField.isHidden.value = false
                    }
                }
        }
        
        return validationField
    }
}
