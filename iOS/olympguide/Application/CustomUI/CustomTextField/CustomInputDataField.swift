//
//  CustomSearchBar.swift
//  olympguide
//
//  Created by Tom Tim on 07.01.2025.
//

import UIKit

// MARK: - CustomSearchBar
final class CustomInputDataField : CustomTextField, HighlightableField {
    typealias Constants = AllConstants.CustomInputDataField.Dimensions
    
    var isWrong: Bool = false
    
    override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        
        if isWrong {
            isWrong = false
            UIView.animate(withDuration: Constants.animationDuration) {
                self.backgroundColor = .white
            }
        }
    }
}
