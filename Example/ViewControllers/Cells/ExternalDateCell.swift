//
//  ExternalDateCell.swift
//  ReactiveForm
//
//  Created by Michael Heinzl on 13.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class ExternalDateCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var field: Form.DateField!
    
    var disposableDataToUi: Disposable?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    func configure(field: Form.DateField) {
        self.field  = field
        
        //Need to reset bindings on configure (cell reuse)
        disposableDataToUi?.dispose()
        
        // Bind field data to UI
        disposableDataToUi = field.date.producer.startWithValues { (date) in
            if let date = date {
                self.dateLabel.text = self.dateFormatter.string(from: date)
                self.dateLabel.textColor = .darkText
            } else {
                self.dateLabel.text = "Birthdate"
                self.dateLabel.textColor = UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1)
            }
        }
    }
    
}

extension ExternalDateCell {
    
    static var descriptor: CellDescriptor<Form.DateField, ExternalDateCell> {
        return CellDescriptor()
            .configure { (field, cell, indexPath) in
                cell.configure(field: field)
        }
    }
}
