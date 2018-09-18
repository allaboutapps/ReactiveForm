//
//  ModalPresentationController.swift
//  
//
//  Created by Matthias Buchetics on 15/02/16.
//  Copyright © 2016 all about apps GmbH. All rights reserved.
//

import UIKit

public class ModalPresentationController: UIPresentationController {

    public var dimBackground: Bool = true
    public var onPresentation: ((UIViewControllerTransitionCoordinator) -> Void)? = nil
    public var onDismissal: ((UIViewControllerTransitionCoordinator) -> Void)? = nil

    public lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.alpha = 0.0

        let tap = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        view.addGestureRecognizer(tap)

        return view
    }()

    // MARK: Transition

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }

        if dimBackground {
            dimmingView.frame = containerView.bounds
            containerView.addSubview(dimmingView)
        }

        containerView.addSubview(presentedView)

        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            }, completion: nil)

            onPresentation?(transitionCoordinator)
        }
    }

    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override public func dismissalTransitionWillBegin() {
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha  = 0.0
            }, completion: nil)

            onDismissal?(transitionCoordinator)
        }
    }

    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    // MARK: Frame

    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }

        let containerSize = containerView.bounds.size
        let contentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerSize)

        return CGRect(
            origin: CGPoint(x: 0, y: containerSize.height - contentSize.height),
            size: contentSize)
    }

    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let height = container.preferredContentSize.height > 0 ? container.preferredContentSize.height : parentSize.height
        return CGSize(width: parentSize.width, height: min(height, parentSize.height))
    }

    override public func containerViewWillLayoutSubviews() {
        guard let containerView = containerView, let presentedView = presentedView else { return }

        dimmingView.frame = containerView.bounds
        presentedView.frame = frameOfPresentedViewInContainerView
    }

    // MARK: Gesture Recognizer

    @objc public func dimmingViewTapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.ended {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
}
