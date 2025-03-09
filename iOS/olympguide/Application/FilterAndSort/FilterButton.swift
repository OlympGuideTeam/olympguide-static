//
//  FilterButton.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
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
        static let arrowSize: CGFloat = 22
    }
}

protocol ScrolledButtonProtocol {
    var filterTitle:  String { get }
    var isSelectedItem: Bool { get set }
}

class FilterButton: UIButton, ScrolledButtonProtocol {
    
    // MARK: - Variables
    private var titleLabelCustom: UILabel = UILabel()
    let plusLabel: UILabel = UILabel()
    let arrowImageView: UIImageView = UIImageView()
    let crossButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return button
    }()
    var filterTitle: String {
        return titleLabelCustom.text ?? ""
    }
    
    private var _isSelectedItem = false
    var isSelectedItem: Bool {
        get { _isSelectedItem }
        set {
            _isSelectedItem = newValue
            if newValue {
                configureSelected()
            } else {
                configureDefault()
            }
        }
    }
    
    var filterInitTitle: String
    
    // MARK: - Lifecycle
    init(
        title: String
    ) {
        self.filterInitTitle = title
        
        super.init(frame: .zero)
        self.titleLabelCustom.text = title
        isUserInteractionEnabled = true
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        addSubview(titleLabelCustom)
        addSubview(crossButton)
        addSubview(arrowImageView)
        addSubview(plusLabel)
        
        layer.cornerRadius = Constants.Dimensions.cornerRadius
        clipsToBounds = true
        
        // Фиксированная высота кнопки
        self.setHeight(Constants.Dimensions.buttonHeight)
        
        // Настройка arrowImageView
        arrowImageView.setWidth(Constants.Dimensions.arrowSize)
        arrowImageView.setHeight(Constants.Dimensions.arrowSize)
        crossButton.setWidth(Constants.Dimensions.arrowSize)
        crossButton.setHeight(Constants.Dimensions.arrowSize)
        
        // Расстановка констрейнтов (пример с использованием методов pin*)
        titleLabelCustom.pinTop(to: self.topAnchor)
        titleLabelCustom.pinLeft(to: self.leadingAnchor, Constants.Dimensions.titleLeftMargin)
        titleLabelCustom.pinBottom(to: self.bottomAnchor, Constants.Dimensions.titleBottomMargin)
//        titleLabelCustom.pinRight(to: crossButton.leadingAnchor, Constants.Dimensions.titleRightMargin)
        
        plusLabel.pinTop(to: self.topAnchor)
        plusLabel.pinLeft(to: titleLabelCustom.trailingAnchor)
        plusLabel.pinRight(to: crossButton.leadingAnchor, Constants.Dimensions.titleRightMargin)
        plusLabel.font = Constants.Fonts.selectedTitleFont
        plusLabel.pinBottom(to: self.bottomAnchor, Constants.Dimensions.titleBottomMargin)
        plusLabel.textColor = UIColor(hex: "#999999")
        
        
        arrowImageView.pinCenterY(to: self)
        crossButton.pinCenterY(to: self)
        crossButton.pinRight(to: self.trailingAnchor, Constants.Dimensions.arrowRightMargin)
        arrowImageView.pinRight(to: self.trailingAnchor, Constants.Dimensions.arrowRightMargin)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = Constants.Colors.arrowTintColor
        let config = UIImage.SymbolConfiguration(weight: .light)
        arrowImageView.image = UIImage(systemName: Constants.Images.arrowImageName, withConfiguration: config)
        crossButton.setImage(UIImage(systemName: Constants.Images.crossImageName), for: .normal)
        crossButton.tintColor = Constants.Colors.crossTintColor
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        configureDefault()
    }
    
    private func configureDefault() {
        crossButton.isHidden = true
        arrowImageView.isHidden = false
        titleLabelCustom.text = filterInitTitle
        backgroundColor = Constants.Colors.defaultBackgroundColor
        titleLabelCustom.font = Constants.Fonts.defaultTitleFont
        titleLabelCustom.textColor = Constants.Colors.defaultTitleTextColor
//        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureSelected() {
        crossButton.isHidden = false
        arrowImageView.isHidden = true
        backgroundColor = Constants.Colors.selectedBackgroundColor
        titleLabelCustom.font = Constants.Fonts.selectedTitleFont
        titleLabelCustom.textColor = Constants.Colors.selectedTitleTextColor
    }
    
    @objc private func crossButtonTapped() {
        plusLabel.text = ""
        configureDefault()
    }
}

extension FilterButton : OptionsViewControllerButtonDelegate {
    func setButtonView(_ options : [OptionViewModel]) {
        plusLabel.text = ""
        if options.isEmpty {
            configureDefault()
        } else  {
            let minOption = options.min(by: { $0.id < $1.id })
            titleLabelCustom.text = minOption?.name ?? options[0].name
            configureSelected()
            if options.count > 1 {
                plusLabel.text = "+\(options.count - 1)"
            }
        }
    }
}

//extension FilterButton : OptionsViewControllerDelegate {
//    func didSelectOption(_ optionsIndicies: Set<Int>, _ optionsNames: [OptionViewModel]) {
//        selectedIndecies = optionsIndicies
////        delegate
//    }
//    
//    func didCancle() { }
//}

