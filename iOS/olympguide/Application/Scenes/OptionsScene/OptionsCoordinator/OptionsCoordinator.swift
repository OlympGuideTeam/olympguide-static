//
//  OptionsCoordinator.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    // MARK: - Colors
    enum Colors {
        static let dimmingViewColor = UIColor.black
        static let containerBackgroundColor = UIColor.white
    }
    
    // MARK: - Dimensions
    enum Dimensions {
        static let containerCornerRadius: CGFloat = 25.0
        static let animateDuration: TimeInterval = 0.3
        static let containerX: CGFloat = 0.0
        static let containerCornerRadiusValue: CGFloat = 25.0
        static let sheetHeightOffset: CGFloat = 100.0
        static let sheetHeightSmall: CGFloat = 157.0
        static let rowHeight: CGFloat = 46.0
    }
    
    // MARK: - Alphas
    enum Alphas {
        static let dimmingViewInitialAlpha: CGFloat = 0.0
        static let dimmingViewFinalAlpha: CGFloat = 0.5
    }
    
    // MARK: - Numbers
    enum Numbers {
        static let rowsLimit: Int = 6
    }
    
    // MARK: - Velocities
    enum Velocities {
        static let maxPanVelocity: CGFloat = 600.0
    }
    
    // MARK: - Fractions
    enum Fractions {
        static let dismissThreshold: CGFloat = 0.5
    }
}


final class OptionsCoordinator: NSObject {
    var containerView: UIView?
    var dimmingView: UIView?
    
    weak var presentingView: OptionsViewController?
    
    private var finalY: CGFloat = 0
    
    var view: UIView {
        guard let presentingView = self.presentingView else {
            return UIView()
        }
        return presentingView.view
    }
    
    func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        containerView?.addGestureRecognizer(panGesture)
    }
    
    
    func configureContainerView(count: Int) {
        guard let containerView = self.containerView else {
            return
        }
        let sheetHeight: CGFloat = count > Constants.Numbers.rowsLimit
        ? view.bounds.height - Constants.Dimensions.sheetHeightOffset
        : Constants.Dimensions.sheetHeightSmall + Constants.Dimensions.rowHeight * CGFloat(count)
        
        containerView.frame = CGRect(
            x: Constants.Dimensions.containerX,
            y: view.bounds.height,
            width: view.bounds.width,
            height: sheetHeight
        )
        containerView.backgroundColor = Constants.Colors.containerBackgroundColor
        containerView.layer.cornerRadius = Constants.Dimensions.containerCornerRadius
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        finalY = view.bounds.height - sheetHeight
    }
    
    func configureDimmingView() {
        guard let dimmingView = self.dimmingView else {
            return
        }
        dimmingView.frame = view.bounds
        dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        view.addSubview(dimmingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: Constants.Dimensions.animateDuration, animations: {
            guard
                let containerView = self.containerView,
                let dimmingView = self.dimmingView,
                let presentingView = self.presentingView
            else {
                return
            }
            containerView.frame.origin.y = presentingView.view.bounds.height
            dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewInitialAlpha)
        }, completion: { _ in
            completion?()
        })
    }
    
    func animateShow() {
        UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
            self.containerView?.frame.origin.y = self.finalY
            self.containerView?.backgroundColor = .white
            self.containerView?.alpha = 1
            self.dimmingView?.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
        }
    }
    
    // MARK: - Pan Gesture Handling
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard
            let containerView = self.containerView,
            let dimmingView = self.dimmingView
        else {
            return
        }
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            let newY = containerView.frame.origin.y + translation.y
            if newY >= finalY {
                containerView.frame.origin.y = newY
                gesture.setTranslation(.zero, in: view)
                
                let totalDistance = view.bounds.height - finalY
                let currentDistance = containerView.frame.origin.y - finalY
                let progress = currentDistance / totalDistance
                let newAlpha = Constants.Alphas.dimmingViewFinalAlpha * (1 - progress)
                dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(newAlpha)
            }
            
        case .ended, .cancelled:
            if velocity.y > Constants.Velocities.maxPanVelocity {
                presentingView?.closeSheet()
            } else {
                let distanceMoved = containerView.frame.origin.y - finalY
                let totalDistance = view.bounds.height - finalY
                
                if distanceMoved > totalDistance * Constants.Fractions.dismissThreshold {
                    presentingView?.closeSheet()
                } else {
                    UIView.animate(withDuration: Constants.Dimensions.animateDuration) {
                        containerView.frame.origin.y = self.finalY
                        dimmingView.backgroundColor = Constants.Colors.dimmingViewColor.withAlphaComponent(Constants.Alphas.dimmingViewFinalAlpha)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    @objc
    private func didTapDimmingView() {
        presentingView?.closeSheet()
    }
}

