//
//  SubjectLabel.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

enum SubjectSide {
    case Single
    case Center
    case Right
    case Left
}

final class SubjectLabel: UILabel {
    typealias Constants = AllConstants.SubjectLabel
    typealias Dimensions = Constants.Dimensions
    typealias Common = AllConstants.Common
    init(text: String, side: SubjectSide) {
        super.init(frame: .zero)
        
        self.text = text
        self.textAlignment = .center
        self.font = FontManager.shared.font(for: .subjectStack)
        self.textColor = Common.Colors.additionalText
        self.layer.borderColor = Common.Colors.additionalText?.cgColor
        self.layer.borderWidth = Dimensions.borderWidth
        self.layer.masksToBounds = true
        
        self.frame.size = Dimensions.size
        
        switch side {
        case .Single:
            self.layer.cornerRadius = Dimensions.radius
        case .Center:
            self.layer.cornerRadius = 0
        case .Right:
            self.layer.cornerRadius = Dimensions.radius
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .Left:
            self.layer.cornerRadius = Dimensions.radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return Dimensions.size
    }
}
