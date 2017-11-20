//
//  ModalTransitioningDelegate.swift
//  
//
//  Created by Matthias Buchetics on 15/02/16.
//  Copyright © 2016 all about apps GmbH. All rights reserved.
//

import UIKit

public class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    public let dimBackground: Bool
    public var onPresentation: ((UIViewControllerTransitionCoordinator) -> ())? = nil
    public var onDismissal: ((UIViewControllerTransitionCoordinator) -> ())? = nil

    public init(dimBackground: Bool) {
        self.dimBackground = dimBackground
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = ModalPresentationController(presentedViewController: presented, presenting: presenting)
        controller.dimBackground = dimBackground
        controller.onPresentation = onPresentation
        controller.onDismissal = onDismissal
        return controller
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimationController(isPresenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimationController(isPresenting: false)
    }
}
