//
//  UICustomTbleView.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class UICustomTbleView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTable() {
        if UIScreen.main.bounds.height > 400 {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
        backgroundColor = .white
        separatorStyle = .none
        refreshControl = refreshControl
        showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        
        register(
            ShimmerCell.self,
            forCellReuseIdentifier: ShimmerCell.identifier
        )
    }
    
    func addHeaderView(_ view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        view.frame.size.height = fittingSize.height
        
        tableHeaderView = view
    }
    
    func addFilterSortView(
        _ filterSortView: FilterSortView,
        top: CGFloat = 13,
        bottom: CGFloat = 21
    ) {
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, top)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor, bottom)
        
        addHeaderView(headerContainer)
    }
}
