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
        
        let register = RegisterViewModel()
        register.tintColor = #colorLiteral(red: 0.6156862745, green: 0.7803921569, blue: 0.2392156863, alpha: 1)
        self.viewControllers = [CardViewController.create(with: register)]
        
    }
    
    
}
