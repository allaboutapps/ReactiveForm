//
//  SegmentedCell.swift
//  SmartSpender
//
//  Created by Gunter Hager on 30.11.17.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import DataSource

class SegmentedCell: FormFieldCell {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func configure(field: FormField<Int>) {
        super.configure(field: field)
        guard field.type == .segmented else { return }
        disposable += segmentedControl.reactive.selectedSegmentIndex <~ field.content.map { $0 ?? 0 }
        disposable += field.content <~ segmentedControl.reactive.selectedSegmentIndexes
        
        disposable += field.validationState <~ segmentedControl.reactive.selectedSegmentIndexes.map { value -> ValidationState in
            return field.validate(value: value)
        }
        
        if let settings = field.settings as? SegmentedFieldSettings {
            segmentedControl.removeAllSegments()
            settings.segments.enumerated().forEach { (index, title) in
                segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
            }
            segmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
}

extension SegmentedCell {
    
    static var descriptor: CellDescriptor<FormField<Int>, SegmentedCell> {
        return CellDescriptor("SegmentedCell", bundle: Bundle(for: SegmentedCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
            }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
