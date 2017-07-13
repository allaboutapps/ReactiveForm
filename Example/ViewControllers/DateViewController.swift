//
//  DateViewController.swift
//  ReactiveForm
//
//  Created by Michael Heinzl on 13.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa
import ReactiveForm

class DateViewController: UIViewController {
    
    var field: Form.DateField!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        field.date.value = datePicker.date
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let date = field.date.value {
            datePicker.date = date
        }
    }

}
