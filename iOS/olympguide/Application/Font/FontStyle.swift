//
//  FontStyle.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import Foundation

enum FontStyle {
    case commonInformation
    case additionalInformation
    case region
    case titleLbel
    case largeTitleLabel
    case textField
    case backButton
    case subjectStack
    case emptyTableLabel
    case bigButton
    case tableTitle
    case timerLabel
    case optionsVCTitle
    case scrollButton
    case selectedScrollButton
    
    var fontSize : CGFloat {
        switch self {
        case .commonInformation:
            return 15.0
        case .additionalInformation:
            return 15.0
        case .titleLbel:
            return 20.0
        case .largeTitleLabel:
            return 28.0
        case .region:
            return 13.0
        case .textField:
            return 14.0
        case .backButton:
            return 17.0
        case .subjectStack:
            return 14.0
        case .emptyTableLabel:
            return 18.0
        case .bigButton:
            return 15.0
        case .tableTitle:
            return 20.0
        case .timerLabel:
            return 10.0
        case .optionsVCTitle:
            return 26.0
        case .scrollButton:
            return 14.0
        case .selectedScrollButton:
            return 14.0
        }
    }
    
    var fontWeight : FontWeight {
        switch self {
        case .commonInformation:
            return .medium
        case .additionalInformation:
            return .regular
        case .titleLbel:
            return .medium
        case .largeTitleLabel:
            return .bold
        case .region:
            return .regular
        case .textField:
            return .regular
        case .backButton:
            return .medium
        case .subjectStack:
            return .regular
        case .emptyTableLabel:
            return .semiBold
        case .bigButton:
            return .medium
        case .tableTitle:
            return .semiBold
        case .timerLabel:
            return .medium
        case .optionsVCTitle:
            return .regular
        case .scrollButton:
            return .regular
        case .selectedScrollButton:
            return .semiBold
        }
    }
}
