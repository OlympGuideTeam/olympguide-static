//
//  Filterble.swift
//  olympguide
//
//  Created by Tom Tim on 09.03.2025.
//

import UIKit

protocol Filterble : OptionsViewControllerDelegate & UIViewController {
    var filterSortView: FilterSortView { get }
    var filterItems: [FilterItem] { get set}
    func presentOptionsVC(forItemAt index: Int, from sender: OptionsViewControllerButtonDelegate?)
    func deleteFilter(forItemAt index: Int)
    func configureFilterSortView()
}

extension Filterble {
    func presentOptionsVC(forItemAt index: Int, from sender: OptionsViewControllerButtonDelegate? = nil) {
        let item = filterItems[index]
        let optionsVC: OptionsViewController
        
        switch item.initMethod {
        case .endpoint(let endpoint):
            optionsVC = OptionsViewController(
                title: item.title,
                isMultipleChoice: item.isMultipleChoice,
                selectedIndices: item.selectedIndices,
                endPoint: endpoint,
                paramType: item.paramType
            )
        case .models(let models):
            optionsVC = OptionsViewController(
                title: item.title,
                isMultipleChoice: item.isMultipleChoice,
                selectedIndices: item.selectedIndices,
                options: models,
                paramType: item.paramType
            )
        }
        
        optionsVC.delegate = self
        optionsVC.buttonDelegate = sender
        optionsVC.modalPresentationStyle = .overFullScreen
        present(optionsVC, animated: false)
    }
    
    func configureFilterSortView() {
        let sortItem = filterItems.first(where: { $0.paramType == .sort })
        let filterItemsWithoutSort = filterItems.filter { $0.paramType != .sort }
        
        filterSortView.configure(
            sortingOption: sortItem?.title,
            filteringOptions: filterItemsWithoutSort.map { $0.title }
        )
        
        filterSortView.sortButttonTapped = { [weak self] _ in
            guard let self = self else { return }
            guard let sortIndex = self.filterItems.firstIndex(where: { $0.paramType == .sort })
            else { return }
            self.presentOptionsVC(forItemAt: sortIndex)
        }
        
        filterSortView.filterButtonTapped = { [weak self] sender in
            guard let self = self else { return }
            let filterIndex = sender.tag + 1
            guard filterIndex < self.filterItems.count else { return }
            
            self.presentOptionsVC(forItemAt: filterIndex, from: sender)
        }
        
        filterSortView.crossButtonTapped = { [weak self] sender in
            guard let self else { return }
            let filterIndex = sender.tag + 1
            guard filterIndex < self.filterItems.count else { return }
            filterItems[filterIndex].selectedParams.clear()
            filterItems[filterIndex].selectedIndices.removeAll()
            deleteFilter(forItemAt: filterIndex)
        }
    }
}

