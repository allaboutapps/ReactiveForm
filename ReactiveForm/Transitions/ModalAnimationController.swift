//
//  ModalAnimationController.swift
//  
//
//  Created by Matthias Buchetics on 15/02/16.
//  Copyright © 2016 all about apps GmbH. All rights reserved.
//

import UIKit

public class ModalAnimationController: NSObject {

    public let isPresenting: Bool
    public let duration: TimeInterval = 0.3

    public init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    public func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let
            presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        let containerView = transitionContext.containerView

        presentedView.frame = transitionContext.finalFrame(for: presentedController)
        presentedView.frame.origin.y = containerView.bounds.height

        containerView.addSubview(presentedView)

        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            presentedView.frame.origin.y = containerView.bounds.height - presentedView.frame.height
        }, completion: { completed in
            transitionContext.completeTransition(completed)
        })
    }

    public func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        let containerView = transitionContext.containerView

        UIView.animate(withDuration: self.duration * 0.7, animations: {
            presentedView.frame.origin.y = containerView.bounds.height
        }, completion: { completed in
            transitionContext.completeTransition(completed)
        })
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ModalAnimationController: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
}
