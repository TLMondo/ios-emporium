//
//  LoadingView.swift
//  Emporium
//
//  Created by Christina on 12/9/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit
import IBAnimatable

class LoadingView: UIView {

    var activityIndicator: UIActivityIndicatorView?

    @IBInspectable
    let activityIndicatorColor: UIColor = .lightGray

    func showLoading() {
        if isLoading() == true {
            return
        }

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func isLoading() -> Bool {
        guard let ai = activityIndicator else {
            return false
        }
        return ai.isAnimating
    }

    func hideLoading() {
        if isLoading() == false {
            return
        }
        activityIndicator?.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }

    private func showSpinning() {
        guard let activityIndicator = self.activityIndicator else {
            return
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInView()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInView() {
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerX,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}

