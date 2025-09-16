//
//  ShowWrong.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

protocol HighlightableField: UIView {
    func highlightError()
    var isWrong: Bool { get set }
}

extension HighlightableField where Self: UIView {
    typealias Common = AllConstants.Common
    
    func highlightError() {
        UIView.animate(withDuration: Common.Dimensions.longDuration) {
            self.backgroundColor = Common.Colors.wrong
        }
        isWrong = true
    }
}
