//
//  UILabel+calculateHeight.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

extension UILabel {
    func calculateHeight(with width: CGFloat) {
        guard
            let labelFont = self.font,
            let text = self.text
        else { return }
        
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: labelFont],
            context: nil
        )
        let calculatedHeight = ceil(boundingBox.height)
        self.setHeight(calculatedHeight)
    }
}
