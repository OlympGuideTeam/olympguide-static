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


extension AllConstants {
    enum UIUniversityView {
        enum Dimensions {
            static let imageSize: CGFloat = 80.0
            static let itemsSpacing: CGFloat = 15.0
            
            static let nameLabelTopMargin: CGFloat = 5.0
            
            static let buttonTopMargin: CGFloat = 5.0
            
            static let arrowImageSize: CGFloat = 17.0
        }
    }
}

extension AllConstants {
    enum AuthManager {
        static let loginEndpoint: String = "/auth/login"
        static let logoutEndpoint: String = "/auth/logout"
        static let checkEndpoint: String = "/auth/check-session"
    }
}

extension AllConstants {
    enum FieldTableViewCell {
        enum Dimensions {
            static let interItemSpacing: CGFloat = 15
            static let favoriteButtonSize: CGFloat = 22
            
            static let leadingMargin: CGFloat = 40.0
            static let topMargin: CGFloat = 5.0
            static let bottomMargin: CGFloat = 5.0
        }
        
        enum Images {
            static let placeholder: UIImage? = UIImage(systemName: "photo")
        }
    }
}

extension AllConstants {
    enum OlympiadTableViewCell {
        enum Dimensions {
            // nameLabel
            static let nameLabelTopMargin: CGFloat = 5.0
            static let nameLabelBottomMargin: CGFloat = 20.0
            
            // nameAndProfileLabel
            static let nameAndProfileTopMargin: CGFloat = 20.0
            
            // favoriteButton
            static let buttonTopMargin: CGFloat = 5.0
            
            // benefitLabel
            static let benefitLabelTopMargin: CGFloat = 5.0
            static let benefitLabelBottomMargin: CGFloat = 5.0
            
            // shimmerLayer
            static let shimmerHeight: CGFloat = 75.0
            static let shimmerRadius: CGFloat = 13.0
            static let shimmerTopMargin: CGFloat = 10.0
            static let shimmerBottomMargin: CGFloat = 10.0
        }
        
        enum Strings {
            static let winnerText: String = "Победитель"
            static let prizeText: String = "Призёр"
        }
    }
}

extension AllConstants {
    enum OptionsTableViewCell {
        enum Images {
            static let multiply: UIImage? = UIImage(systemName: "square")
        }
        
        enum Dimensions {
            static let titleRightMargin: CGFloat = 8.0
            
            static let buttonSize: CGFloat = 24.0
        }
    }
}

extension AllConstants {
    enum ProfileButtonTableViewCell {
        enum Dimensions {
            // actionButton
            static let buttonRadius: CGFloat = 13.0
            static let buttonBorderWidth: CGFloat = 2.0
            static let buttonVerticalMargin: CGFloat = 8.0
            static let buttonHeight: CGFloat = 54.0
            
            static let animationDuration: TimeInterval = 0.1
            
            static let buttonScale: CGFloat = 0.95
        }
    }
}

extension AllConstants {
    enum ProfileTableViewCell {
        enum Images {
            static let chevronImage: UIImage? = UIImage(systemName: "chevron.right")
        }
        
        enum Dimensions {
            static let chevronWidth: CGFloat = 13.0
            static let chevronHeight: CGFloat = 22.0
            
            static let itemSpacing: CGFloat = 4.0
            
            static let verticalMargin: CGFloat = 21.0
        }
        
        enum Colors {
            static let chevronColor: UIColor = .black
        }
    }
}

extension AllConstants {
    enum ProgramTableViewCell {
        enum Dimensions {
            static let leadingMargin: CGFloat = 40.0
            
            static let informationTopMargin: CGFloat = 5.0
            static let informationRightMargin: CGFloat = 15.0
            
            static let blocksSpacing: CGFloat = 11.0
            
            static let spacing: CGFloat = 7.0
        }
        
        enum Strings {
            static let budgetText: String = "Бюджетных мест  "
            static let paidText: String = "Платных мест  "
            static let costText: String = "Стоимость  "
        }
    }
}

extension AllConstants {
    enum UIProgramWithBenefitsCell {
        enum Dimensions {
            // nameStack
            static let nameStackTopMargin: CGFloat = 10.0
            
            // benefitsStack
            static let benefitStackTopMargin: CGFloat = 5.0
            static let benefitStackBottompMargin: CGFloat = 10.0
            static let benefitStackBottompSpacing: CGFloat = 10.0
        }
    }
}

extension AllConstants {
    enum UniversityTableViewCell {
        enum Dimensions {
            // universityView
            static let universityTopMargin: CGFloat = 30.0
            
            // separatorLine
            static let separatorTopMargin: CGFloat = 20.0
            
            // shimmerLayer
            static let shimmerHeight: CGFloat = 75.0
            static let shimmerRadius: CGFloat = 13.0
            static let shimmerVerticalMargin: CGFloat = 10.0
        }
    }
}

extension AllConstants {
    enum CustomDatePicker {
        enum Dimensions {
            static let userAge: Int = 16
            
            static let startMonth: Int = 1
            static let startDay: Int = 1
        }
        
        enum Strings {
            static let dateFormat: String = "dd.MM.yyyy"
        }
    }
}

extension AllConstants {
    enum CustomInputDataField {
        enum Dimensions {
            static let animationDuration: TimeInterval = 0.2
        }
    }
}

extension AllConstants {
    enum CustomPasswordField {
        enum Images {
            static let show: UIImage? = UIImage(systemName: "eye")
            static let hide: UIImage? = UIImage(systemName: "eye.slash")
        }
    }
}

extension AllConstants {
    enum CustomTextField {
        enum Colors {
            static let titleTextColor = UIColor(hex: "#4F4F4F")
            static let backgroundColor = UIColor(hex: "#E7E7E7")
            static let activeBackgroundColor = UIColor.white
            static let borderColor = UIColor.black
        }
        
        enum Dimensions {
            static let cornerRadius: CGFloat = 13
            static let padding: CGFloat = 10
            static let searchBarHeight: CGFloat = 48
            static let textFieldHeight: CGFloat = 24
            static let titleScale: CGFloat = 0.5
            static let titleTranslateY: CGFloat = -8
            static let animationDuration: TimeInterval = 0.3
            static let activeBorderWidth: CGFloat = 1
            static let inactiveBorderWidth: CGFloat = 0
        }
        
        enum Strings {
            static let closeButtonTitle = "Закрыть"
            static let deleteButtonImage = "xmark.circle.fill"
        }
    }
}

extension AllConstants {
    enum RegionTextField {
        enum Strings {
            static let optionVCTitle = "Регион"
        }
    }
}

extension AllConstants {
    enum UIFieldHeaderCell {
        enum Dimensions {
            static let backgroundVerticalMargin: CGFloat = 15.0
            static let backroundRadius: CGFloat = 13.0
            
            static let fieldStackVerticalMargin: CGFloat = 5.0
            
            static let leftMargin: CGFloat = 40.0
            
            static let arrowTopMargin: CGFloat = 3.0
            static let arrowSize: CGFloat = 17.0
        }
        
        enum Strings {
            static let optionVCTitle = "Регион"
        }
    }
}
