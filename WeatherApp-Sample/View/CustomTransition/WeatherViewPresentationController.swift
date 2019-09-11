//
//  WeatherViewPresentationController.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/11.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

protocol WeatherViewCustomPresentable: UIViewController {
    var backgroundView: UIView! { get }
}

final class WeatherViewPresentationController: UIPresentationController {

    /// Present時
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView,
            let presented = presentedViewController as? WeatherViewCustomPresentable else { return }

        presented.backgroundView.alpha = 0.0

        let backgroundView = UIView(frame: presented.view.bounds)
        backgroundView.backgroundColor = presented.backgroundView.backgroundColor
        containerView.addSubview(backgroundView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (_) in
            presented.backgroundView.alpha = 1.0
            backgroundView.removeFromSuperview()
        })
    }

    /// Dismiss時

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let containerView = containerView,
            let presented = presentedViewController as? WeatherViewCustomPresentable else { return }

        presented.backgroundView.alpha = 0.0

        let backgroundView = UIView(frame: presented.view.bounds)
        backgroundView.backgroundColor = presented.backgroundView.backgroundColor
        containerView.insertSubview(backgroundView, aboveSubview: presented.backgroundView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (_) in
            backgroundView.removeFromSuperview()
        })
    }
}
