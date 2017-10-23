//
//  NavigationController.swift
//  SmartSpender
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [CardViewController.create(with: HomeViewModel())]
        
    }
    
    
}
