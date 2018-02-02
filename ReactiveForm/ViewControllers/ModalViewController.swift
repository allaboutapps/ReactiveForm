//
//  ModalViewController.swift
//  
//
//  Created by Matthias Buchetics on 15/02/16.
//  Copyright © 2016 all about apps GmbH. All rights reserved.
//

import UIKit

open class ModalViewController: UIViewController {

    //swiftlint:disable weak_delegate
    public let modalTransitioningDelegate = ModalTransitioningDelegate(dimBackground: true)

    override open func awakeFromNib() {
        super.awakeFromNib()

        modalPresentationStyle = .custom
        transitioningDelegate = modalTransitioningDelegate
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let size = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        preferredContentSize = CGSize(width: 0, height: size.height)
    }
}
