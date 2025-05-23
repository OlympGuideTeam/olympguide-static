//
//  FilterSortView.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

protocol FilterSortViewDelegate: AnyObject {
    func filterSortViewDidTapSortButton(_ view: FilterSortView)
    func filterSortView(_ view: FilterSortView, didTapFilterWith title: String)
}

final class FilterSortView: UIView {
    typealias Constants = AllConstants.FilterSortView
    // MARK: - Variables
    weak var delegate: FilterSortViewDelegate?
    
    var sortButttonTapped: ((_: UIButton) -> Void)?
    var filterButtonTapped: ((_: FilterButton) -> Void)?
    var crossButtonTapped: ((_: UIButton) -> Void)?
    
    private lazy var horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.Dimensions.stackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Lifecycle
    init(sortingOptions: [String], filteringOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
    }
    
    init (filteringOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .clear
        addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(horizontalStackView)
        
        horizontalScrollView.pinLeft(to: leadingAnchor)
        horizontalScrollView.pinRight(to: trailingAnchor)
        horizontalScrollView.pinTop(to: topAnchor)
        horizontalScrollView.pinBottom(to: bottomAnchor)
        
        horizontalStackView.pinLeft(to: horizontalScrollView.leadingAnchor, Constants.Dimensions.scrollViewInset)
        horizontalStackView.pinRight(to: horizontalScrollView.trailingAnchor, Constants.Dimensions.scrollViewInset)
        horizontalStackView.pinTop(to: horizontalScrollView.topAnchor)
        horizontalStackView.pinBottom(to: horizontalScrollView.bottomAnchor)
        horizontalStackView.pinHeight(to: horizontalScrollView)
    }
    
    func configure(
        sortingOption: String?,
        filteringOptions: [String]
    ) {
        guard sortingOption != nil else {
            configure(filteringOptions: filteringOptions)
            return
        }
        
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let space = UIView()
        space.setWidth(Constants.Dimensions.spaceWidth)
        horizontalStackView.addArrangedSubview(space)
        
        let sortButton = createSortButton()
        horizontalStackView.addArrangedSubview(sortButton)
        
        for (index ,filterName) in filteringOptions.enumerated() {
            let filterButton = createFilterButton(with: filterName, tag: index)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    func configure(filteringOptions: [String]) {
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let space = UIView()
        space.setWidth(Constants.Dimensions.spaceWidth)
        horizontalStackView.addArrangedSubview(space)
        
        for (index ,filterName) in filteringOptions.enumerated() {
            let filterButton = createFilterButton(with: filterName, tag: index - 1)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    private func createSortButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Images.sortIcon), for: .normal)
        button.tintColor = Constants.Colors.tintColor
        button.setWidth(Constants.Dimensions.sortButtonSize)
        button.setHeight(Constants.Dimensions.sortButtonSize)
        button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createFilterButton(with title: String, tag: Int) -> UIButton {
        let button = FilterButton(title: title)
        button.tag = tag
        button.crossButton.tag = tag
        button.tintColor = .black
        button.crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let filterButton = sender as? FilterButton else { return }
        filterButtonTapped?(filterButton)
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        sortButttonTapped?(sender)
    }
    
    @objc func crossButtonTapped(_ sender: UIButton) {
        crossButtonTapped?(sender)
    }
}
