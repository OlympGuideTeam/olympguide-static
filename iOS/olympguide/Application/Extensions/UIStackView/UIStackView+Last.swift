//
//  UIStackView+Lasr.swift
//  olympguide
//
//  Created by Tom Tim on 09.03.2025.
//

import UIKit

extension UIStackView {
    var last: UIView? {
        arrangedSubviews.last
    }
    
    func pinToPrevious(_ const: CGFloat = 0) {
        if let previous = last {
            setCustomSpacing(const, after: previous)
        }
    }
}
