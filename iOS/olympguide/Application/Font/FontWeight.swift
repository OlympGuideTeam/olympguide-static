//
//  FontWeight.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import UIKit

enum FontWeight : String {
    case bold = "Bold"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"
    
    var systemWeight : UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .bold:
            return .bold
        case .light:
            return .light
        case .semiBold:
            return .semibold
        case .thin:
            return .thin
        }
    }
}
