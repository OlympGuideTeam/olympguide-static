//
//  FontManager.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import UIKit

class FontManager {
    static let shared = FontManager()
    
    var fontFamilyName: String = "MontserratAlternates"
    
    var globalFontScale: CGFloat = 1.0
    
    private init() { }

    func font(
        for style: FontStyle,
        weight: FontWeight? = nil,
        size: CGFloat? = nil
    ) -> UIFont {
        let baseSize: CGFloat = style.fontSize
        let finalSize = (size ?? baseSize) * globalFontScale
        let weight = weight ?? style.fontWeight
        
        let fontName = "\(fontFamilyName)-\(weight.rawValue)"
        
        if let customFont = UIFont(name: fontName, size: finalSize) {
            return customFont
        } else {
            return UIFont.systemFont(ofSize: finalSize, weight: weight.systemWeight)
        }
    }
    
    func font(
        weight: FontWeight = .regular,
        size: CGFloat = 15.0
    ) -> UIFont {
        let finalSize = size * globalFontScale
        let fontName = "\(fontFamilyName)-\(weight.rawValue)"
        
        if let customFont = UIFont(name: fontName, size: finalSize) {
            return customFont
        } else {
            return UIFont.systemFont(ofSize: finalSize, weight: weight.systemWeight)
        }
    }
}
