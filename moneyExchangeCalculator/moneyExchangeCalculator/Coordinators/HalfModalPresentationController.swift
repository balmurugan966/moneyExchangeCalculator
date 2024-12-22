//
//  HalfModalPresentationController.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 21/12/24.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    private var blurEffectView: UIVisualEffectView?

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height = containerView.bounds.height * 0.5
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        // Create and configure the blur effect
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = containerView.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Add the blur effect to the container view
        if let blurEffectView = blurEffectView {
            containerView.insertSubview(blurEffectView, at: 0)
        }

        // Fade in the blur effect
        blurEffectView?.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView?.alpha = 1
        })
    }


    override func dismissalTransitionWillBegin() {
        // Fade out the blur effect
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView?.alpha = 0
        }, completion: { _ in
            self.blurEffectView?.removeFromSuperview()
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 16
        presentedView?.clipsToBounds = true
    }
}
