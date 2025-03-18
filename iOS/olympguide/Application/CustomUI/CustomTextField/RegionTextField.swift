//
//  RegionTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

protocol RegionTextFieldDelegate: AnyObject {
    func regionTextFieldDidSelect(region: Int)
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController)
    func dissmissKeyboard()
}

protocol RegionDelegateOwner: AnyObject {
    var regionDelegate: RegionTextFieldDelegate? { get set }
}

final class RegionTextField: CustomTextField, HighlightableField, RegionDelegateOwner {
    typealias Constants = AllConstants.RegionTextField.Strings
    
    var isWrong: Bool = false
    weak var regionDelegate: RegionTextFieldDelegate?
    var selectedIndecies: Set<Int> = []
    private var endPoint: String = ""

    init(with title: String, endPoint: String) {
        self.endPoint = endPoint
        super.init(with: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        regionDelegate?.dissmissKeyboard()
        textField.resignFirstResponder()
        
        if !isActive {
            isActive = true
            updateAppereance()
        }
        presentOptions()
    }

    private func presentOptions() {
        let optionVC = OptionsAssembly.build(
            title: Constants.optionVCTitle,
            isMultipleChoice: false,
            selectedIndices: selectedIndecies,
            endPoint: endPoint
        )
        optionVC.delegate = self
        regionDelegate?.regionTextFieldWillSelect(with: optionVC)
    }

    override func didTapDeleteButton() {
        super.didTapDeleteButton()
        selectedIndecies.removeAll()
    }
}

// MARK: - OptionsViewControllerDelegate
extension RegionTextField: OptionsViewControllerDelegate {
    func didSelectOption(
        _ optionsIndicies: Set<Int>,
        _ optionsNames: [OptionViewModel],
        paramType: ParamType?
    ) {
        selectedIndecies = optionsIndicies
        if optionsIndicies.isEmpty {
            setTextFieldText("")
        } else {
            setTextFieldText(optionsNames[0].name)
            regionDelegate?.regionTextFieldDidSelect(region: optionsNames[0].id)
        }
        textFieldSendAction(for: .editingChanged)
    }

    func didCancle() {
        textFieldSendAction(for: .editingChanged)
    }
}
