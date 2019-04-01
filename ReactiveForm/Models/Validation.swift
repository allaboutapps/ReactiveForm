//
//  Validation.swift
//  
//
//  Created by Gunter Hager on 12/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import JavaScriptCore

open class Validation {
    
    private let context: JSContext? = {
        let result = JSContext()
        result?.exceptionHandler = { context, exception in
            print("❌ JavaScript: \(exception?.description ?? "unknown error")")
        }
        return result
    }()
    
    public static var shared = Validation()
    
    private func clearContext() {
        guard let context = context else { return }
        context.setObject(nil, forKeyedSubscript: "value" as NSString)
        context.setObject(nil, forKeyedSubscript: "form" as NSString)
    }
    
    private func validate(_ rule: String) -> Bool {
        guard let context = context else { return false }
        let jsValue = context.evaluateScript(rule)
        return jsValue?.toBool() ?? false
    }
    
    public func validate(value: Any?, withRule rule: String) -> Bool {
        guard let context = context else { return false }
        clearContext()
        context.setObject(value, forKeyedSubscript: "value" as NSString)
        return validate(rule)
    }
    
    public func validate(form: [String: Any?], withRule rule: String) -> Bool {
        guard let context = context else { return false }
        clearContext()
        context.setObject(form, forKeyedSubscript: "form" as NSString)
        return validate(rule)
    }
    
}
