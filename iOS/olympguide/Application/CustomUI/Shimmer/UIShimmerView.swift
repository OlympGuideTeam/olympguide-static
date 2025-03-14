//
//  ShimmerView.swift
//  vmpankratovPW5
//
//  Created by Tom Tim on 17.12.2024.
//

import UIKit

final class UIShimmerView: UIView {
    typealias Constants = AllConstants.UIShimmerView
    
    // MARK: - Private Properties
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Public Methods
    func startAnimating() {
        guard gradientLayer == nil else { return }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = Constants.startPoint
        gradient.endPoint = Constants.endPoint
        gradient.colors = [
            Constants.firstGradientColor,
            Constants.secondGradientColor,
            Constants.firstGradientColor
        ]
        gradient.locations = Constants.gradientLayerLocations
        gradient.cornerRadius = layer.cornerRadius
        layer.addSublayer(gradient)
        gradientLayer = gradient
        
        addShimmerAnimation()
    }
    
    func stopAnimating() {
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            gradientLayer?.removeAllAnimations()
        } else {
            addShimmerAnimation()
        }
    }
    
    private func addShimmerAnimation() {
        guard let gradient = gradientLayer else { return }
        
        let animation = CABasicAnimation(keyPath: Constants.keyPath)
        animation.fromValue = Constants.fromValue
        animation.toValue = Constants.toValue
        animation.duration = Constants.animationDuration
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmerAnimation")
    }
}
