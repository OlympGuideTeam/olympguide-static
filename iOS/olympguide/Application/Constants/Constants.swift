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
        static let googleEndpoint: String = "/auth/google"
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
            static let benefitLabelBottomMargin: CGFloat = 15.0
            
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

extension AllConstants {
    enum UIUniversityHeaderCell {
        enum Dimensions {
            // universityView
            static let universityTopMargin: CGFloat = 20.0
            static let universityBottomMargin: CGFloat = 15.0
            
            // background
            static let backgroundHorizontalMargin: CGFloat = 7
            static let backgroundRadius: CGFloat = 10.0
            static let backgroundVerticalMargin: CGFloat = 5.0
        }
    }
}

extension AllConstants {
    enum SubjectLabel {
        enum Dimensions {
            static let borderWidth: CGFloat = 1.0
            static let radius: CGFloat = 5.0
            static let size: CGSize = CGSize(width: 34, height: 34)
        }
    }
}

extension AllConstants {
    enum UIShimmerView {
        static let firstGradientColor: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        static let secondGradientColor: CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        
        static let startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)
        static let endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)
        
        static let gradientLayerLocations: [NSNumber] = [0.0, 0.5, 1.0]
        
        static let keyPath: String = "locations"
        
        static let fromValue: [NSNumber] = [-1.0, -0.5, 0.0]
        static let toValue: [NSNumber] = [1.0, 1.5, 2.0]
        
        static let animationDuration = 0.9
    }
}

extension AllConstants {
    enum InformationAboutFieldStack {
        enum Dimensions {
            // nameLabel
            static let nameTopMargin: CGFloat = 10.0
            static let nameFontSize: CGFloat = 17.0
            
            // filterSortView
            static let fswTopMargin: CGFloat = 13.0
            
            // programsTitleLabel
            static let progrmmsTitleBottomMargin: CGFloat = 5.0
            
            static let itemsSpacing: CGFloat = 17.0
        }
        
        enum Strings {
            // degreeLabel
            static let degreeText: String = "Степень: "
            
            // programsTitleLabel
            static let programsText: String = "Программы: "
        }
    }
}

extension AllConstants {
    enum FilterButton {
        enum Images {
            static let arrowImageName = "chevron.down"
            static let crossImageName = "xmark.circle.fill"
        }
        
        enum Colors {
            static let defaultBackgroundColor = UIColor(hex: "#EBEBEC")
            static let selectedBackgroundColor = UIColor(hex: "#1B1F26", alpha: 0.72)
            static let arrowTintColor = UIColor.black
            static let crossTintColor = UIColor(hex: "#999999")
            static let defaultTitleTextColor = UIColor.black
            static let selectedTitleTextColor = UIColor.white
        }
        
        enum Fonts {
            static let defaultTitleFont = FontManager.shared.font(for: .scrollButton)
            static let selectedTitleFont = FontManager.shared.font(for: .selectedScrollButton)
        }
        
        enum Dimensions {
            static let cornerRadius: CGFloat = 15.5
            static let buttonHeight: CGFloat = 31
            static let titleBottomMargin: CGFloat = 2
            static let titleLeftMargin: CGFloat = 16
            static let titleRightMargin: CGFloat = 6
            static let arrowRightMargin: CGFloat = 10
            static let arrowSize: CGFloat = 28
        }
    }
}

extension AllConstants {
    enum FilterSortView {
        enum Images {
            static let sortIcon = "arrow.up.arrow.down"
        }
        
        enum Colors {
            static let tintColor = UIColor.black
        }
        
        enum Dimensions {
            static let stackViewSpacing: CGFloat = 5
            static let scrollViewInset: CGFloat = 8
            static let spaceWidth: CGFloat = 7
            static let sortButtonSize: CGFloat = 28
        }
    }
}

extension AllConstants {
    enum SelectedScrollView {
        enum Colors {
            static let tintColor = UIColor.black
        }
        
        enum Dimensions {
            static let stackViewSpacing: CGFloat = 5
            static let scrollViewInset: CGFloat = 8
            static let spaceWidth: CGFloat = 7
            static let sortButtonSize: CGFloat = 28
        }
    }
}

extension AllConstants {
    enum SignInViewController {
        enum Dimensions {
            static let emailTextFieldTop: CGFloat = 16
            static let emailTextFieldLeft: CGFloat = 20
            static let passwordTextFieldTop: CGFloat = 24
            static let passwordTextFieldLeft: CGFloat = 20
            static let nextButtonHeight: CGFloat = 48
            static let nextButtonCornerRadius: CGFloat = 13
            static let nextButtonBottomOffsetDefault: CGFloat = -43
            static let nextButtonBottomOffsetKeyboard: CGFloat = -10
        }
        
        enum Strings {
            static let title = "Вход"
            static let emailPlaceholder = "email"
            static let passwordPlaceholder = "пароль"
            static let nextButtonTitle = "Войти"
        }
        
        enum Colors {
            static let nextButtonBackground = "#E0E8FE"
            static let nextButtonText = UIColor.black
        }
    }
}

extension AllConstants {
    enum EnterEmailViewController {
        enum Strings {
            static let title = "Регистрация"
            static let nextButtonTitle = "Продолжить"
        }
        
        enum Dimensions {
            static let emailTextFieldTopPadding: CGFloat = 16.0
            static let horizontalMargin: CGFloat = 20.0
            static let nextButtonCornerRadius: CGFloat = 13.0
            static let nextButtonHeight: CGFloat = 48.0
            static let nextButtonBottomPadding: CGFloat = 43.0
            static let keyboardBottomPadding: CGFloat = 10.0
        }
        
        enum Colors {
            static let nextButtonBackground: UIColor? = UIColor(hex: "#E0E8FE")
            static let nextButtonText: UIColor = .black
            static let background: UIColor = .white
        }
    }
}

extension AllConstants {
    enum InformationAboutOlympStack {
        enum Dimensions {
            static let stackSpacing: CGFloat = 17.0
            static let searchButtonSize: CGFloat = Common.Dimensions.searchButtonSize
            static let layoutMarginTop: CGFloat = 15.0
            static let layoutMarginHorizontal: CGFloat = Common.Dimensions.horizontalMargin
            static let layoutMarginBottom: CGFloat = 0.0
            static let olympiadInfoSpacing: CGFloat = 7.0
            static let pinBottomOffset: CGFloat = 5.0
            static let pinToPreviousOffset: CGFloat = 49.0 // 13 + 31 + 5
        }
        
        enum Colors {
            static let additionalText = Common.Colors.additionalText
            static let text = Common.Colors.text
        }
        
        enum Strings {
            static let levelPrefix = "Уровень: "
            static let profilePrefix = "Профиль: "
            static let programsTitle = "Программы"
        }
    }
}

extension AllConstants {
    enum OptionsViewController {
        
        
        // MARK: - Colors
        enum Colors {
            static let dimmingViewColor = UIColor.black
            static let peakColor = UIColor(hex: "#D9D9D9")
            static let cancelButtonBackgroundColor = UIColor(hex: "#E7E7E7")
            static let saveButtonBackgroundColor = UIColor(hex: "#E0E8FE")
            static let titleLabelTextColor = UIColor.black
            static let cancelButtonTextColor = UIColor.black
            static let saveButtonTextColor = UIColor.black
            static let containerBackgroundColor = UIColor.white
        }
        
        // MARK: - Fonts
        enum Fonts {
            static let titleLabelFont = FontManager.shared.font(for: .optionsVCTitle)
            static let buttonFont = FontManager.shared.font(for: .bigButton)
        }
        
        // MARK: - Dimensions
        enum Dimensions {
            static let peakCornerRadius: CGFloat = 1.0
            static let containerCornerRadius: CGFloat = 25.0
            static let peakWidth: CGFloat = 45.0
            static let peakHeight: CGFloat = 3.0
            static let peakTopMargin: CGFloat = 6.0
            static let titleLabelTopMargin: CGFloat = 21.0
            static let titleLabelHorizontalMargin: CGFloat = 20.0
            static let buttonHeight: CGFloat = 48.0
            static let buttonBottomMargin: CGFloat = 37.0
            static let buttonLeftRightMargin: CGFloat = 20.0
            static let buttonSpacing: CGFloat = 2.5
            static let tableViewTopMargin: CGFloat = 5.0
            static let animateDuration: TimeInterval = 0.3
            static let containerX: CGFloat = 0.0
            static let containerCornerRadiusValue: CGFloat = 25.0
            static let sheetHeightOffset: CGFloat = 100.0
            static let sheetHeightSmall: CGFloat = 157.0
            static let rowHeight: CGFloat = 46.0
            static let buttonCornerRadius: CGFloat = 14.0
        }
        
        // MARK: - Alphas
        enum Alphas {
            static let dimmingViewInitialAlpha: CGFloat = 0.0
            static let dimmingViewFinalAlpha: CGFloat = 0.5
        }
        
        // MARK: - Numbers
        enum Numbers {
            static let rowsLimit: Int = 6
        }
        
        // MARK: - Velocities
        enum Velocities {
            static let maxPanVelocity: CGFloat = 600.0
        }
        
        // MARK: - Fractions
        enum Fractions {
            static let dismissThreshold: CGFloat = 0.5
        }
        
        // MARK: - Images
        enum Images {
            static var filledSquare: String {
                if #available(iOS 18.0, *) {
                    return "inset.filled.square"
                } else {
                    return "square.inset.filled"
                }
            }
            static let square = "square"
            static var filledCircle: String {
                if #available(iOS 18.0, *) {
                    return "inset.filled.circle"
                } else {
                    return "circle.inset.filled"
                }
            }
            static let circle = "circle"
        }
        
        // MARK: - Strings
        enum Strings {
            static let cancel = "Отменить"
            static let apply = "Применить"
        }
    }
}
