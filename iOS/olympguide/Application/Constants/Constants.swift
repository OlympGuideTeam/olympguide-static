//
//  AllConstants.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

enum AllConstants {
    enum Common {
        enum Images {
            static let unlike: UIImage? = UIImage(systemName: "bookmark")
            static let like: UIImage? = UIImage(systemName: "bookmark.fill")
            
            static let closedSection: UIImage? = UIImage(systemName: "chevron.down")
            static let openedSection: UIImage? = UIImage(systemName: "chevron.up")
            
            static let search: UIImage? = UIImage(systemName: "magnifyingglass")
            
            static let cancel: UIImage? = UIImage(systemName: "xmark.circle.fill")
        }
        
        enum Colors {
            static let text: UIColor = .black
            static let additionalText: UIColor? = UIColor(hex: "#787878")
            
            static let main: UIColor = .white
            static let accient: UIColor? = UIColor(hex: "#E0E8FE")
            static let supporting: UIColor? = UIColor(hex: "#E7E7E7")
            
            static let separator: UIColor? = UIColor(hex: "#D9D9D9")
            
            static let wrong: UIColor? = UIColor(hex: "#FFCDCD")
        }
        
        enum Dimensions {
            static let horizontalMargin: CGFloat = 20.0
            
            static let separatorHeight: CGFloat = 1.0
            
            static let favoriteButtonSize: CGFloat = 22.0
            
            static let shortDuration: TimeInterval = 0.1
            static let middleDuration: TimeInterval = 0.2
            static let longDuration: TimeInterval = 0.3
            
            static let searchButtonSize: CGFloat = 28.0
        }
    }
}

