//
//  Form.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 07.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

public class Form {
    
    public init() {}
    
    // MARK: - Import & Export
    
    public func importFieldData(from dict:[String : Any?]) {
        let fieldDict = fields
            .reduce([String : Field]()) { (dict, field) in
                var varDict = dict
                varDict[field.identifier] = field
                return varDict
        }
        dict.forEach { (key, value) in
            if let field = fieldDict[key] {
                field.anyValue = value
            }
        }
    }
    
    public func exportFieldData(with filter: ((Field) -> Bool)? = nil) -> [String : Any?] {
        return fields
            .reduce([String : Any?]()) { (dict, field) in
                guard !(field is ValidationField) else { return dict }
                guard filter?(field) ?? true else { return dict }
                var varDict = dict
                varDict[field.identifier] = field.anyValue
                return varDict
        }
    }
    
    public var onSubmit: ((_ data: [String : Any?], _ sender: Form.Field?) -> Void)? = nil
    
    public func submit(sender: Form.Field? = nil) {
        onSubmit?(exportFieldData(), sender)
    }
    
    // MARK: - Change
    
    public var sections = [SectionType]()
    
    public var didChange: (() -> Void)? = nil
    
    private var changeDisposable: Disposable?
    private var enableDisposable: Disposable?
    
    internal var fields = [Field]()
    
    public func setup() {
        updateFields()
        setFormOnFields()
        updateChange()
        updateEnabled()
    }
    
    private func updateFields() {
        fields.removeAll()
        for section in sections {
            if let dataSourceSection = section as? Section {
                let fieldsFromSection = dataSourceSection.fields()
                fields.append(contentsOf: fieldsFromSection)
            }
        }
    }
    
    private func setFormOnFields() {
        fields.forEach { (field) in
            field.form = self
        }
    }
    
    private func updateChange() {
        changeDisposable?.dispose()
        changeDisposable =  SignalProducer
            .combineLatest(fields.map { $0.isHidden.producer })
            .throttle(0, on: QueueScheduler.main)
            .combinePrevious(fields.map { $0.isHidden.value })
            .startWithValues { [unowned self] (isHiddenFlags, previousHiddenFlags) in
                if isHiddenFlags != previousHiddenFlags {
                    print("reload UI")
                    
                    // Fix: Reload of input views cause tableview reload animation to bug
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        self.updateReturnKeys()
                    })
                    self.didChange?()
                }
        }
    }
    
    private func updateEnabled() {
        enableDisposable?.dispose()
        enableDisposable = SignalProducer
            .combineLatest(fields.map { $0.isEnabled.producer })
            .startWithValues { [unowned self] (values) in
                self.updateReturnKeys()
        }
    }
    
    // MARK: - Return key
    
    public var shouldAdaptedReturnKey = true
    
    public var returnKey: UIReturnKeyType = .send
    public var nextKey: UIReturnKeyType = .next
    public var defaultKey: UIReturnKeyType = .default
    
    private func updateReturnKeys() {
        focusableFields.forEach { $0.configureReturnKey?() }
    }
    
}


