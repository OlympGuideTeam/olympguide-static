//
//  OptionAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

final class OptionsAssembly {
    static func build(
        title: String,
        isMultipleChoice: Bool,
        selectedIndices: Set<Int>,
        options: [OptionViewModel],
        paramType: ParamType? = nil
    ) -> OptionsViewController {
        let viewController = OptionsViewController(
            title: title,
            isMultipleChoice: isMultipleChoice,
            selectedIndices: selectedIndices,
            options: options,
            paramType: paramType
        )
        
        let interactor = OptionsViewInteractor()
        let presenter = OptionViewPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func build(
        title: String,
        isMultipleChoice: Bool,
        selectedIndices: Set<Int>,
        endPoint: String,
        paramType: ParamType? = nil
    ) -> OptionsViewController {
        let viewController = OptionsViewController(
            title: title,
            isMultipleChoice: isMultipleChoice,
            selectedIndices: selectedIndices,
            endPoint: endPoint,
            paramType: paramType
        )
        
        let interactor = OptionsViewInteractor()
        let presenter = OptionViewPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
