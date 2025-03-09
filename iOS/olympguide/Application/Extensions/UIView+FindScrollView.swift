//
//  UIView+FindScrollView.swift
//  olympguide
//
//  Created by Tom Tim on 10.03.2025.
//

import UIKit

extension UIView {
    func findScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        for subview in self.subviews {
            if let found = subview.findScrollView() {
                return found
            }
        }
        return nil
    }
}
