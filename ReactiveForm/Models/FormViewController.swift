//
//  FormViewController.swift
//  ReactiveForm
//
//  Created by Gunter Hager on 22.11.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit

public protocol FormViewController where Self: UIViewController {
    
    var tableView: UITableView! { get }
    
}
