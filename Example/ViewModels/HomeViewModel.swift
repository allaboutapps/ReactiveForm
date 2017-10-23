//
//  HomeViewModel.swift
//  Example
//
//  Created by Gunter Hager on 23.10.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveForm

class HomeViewModel: CardViewModel {
    
    override init() {
        super.init()
        
        tintColor = #colorLiteral(red: 0.6156862745, green: 0.7803921569, blue: 0.2392156863, alpha: 1)
        
        setFields([
            Form.Field<Empty>(type: .title, title: "Home"),
            Form.Field<Empty>(type: .button, title: "Registrieren")
                .buttonAction { field in
                    guard let controller = self.viewController else { return }
                    let setup = CardViewController.create(with: RegisterViewModel())
                    controller.show(setup, sender: controller)
            },
            Form.Field<Empty>(type: .button, title: "Einstellungen")
                .buttonAction { field in
                    guard let controller = self.viewController else { return }
                    let setup = CardViewController.create(with: SettingsViewModel())
                    controller.show(setup, sender: controller)
            },
        ])
        
    }
    
}

