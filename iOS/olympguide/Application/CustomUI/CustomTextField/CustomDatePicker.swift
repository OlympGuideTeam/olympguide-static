//
//  CustomDatePicker.swift
//  olympguide
//
//  Created by Tom Tim on 29.01.2025.
//

import UIKit

// MARK: - CustomDatePicker
final class CustomDatePicker: CustomTextField, HighlightableField {
    typealias Constants = AllConstants.CustomDatePicker
    
    var isWrong: Bool = false
    
    private let datePicker: UIDatePicker = UIDatePicker()
    
    override init(with title: String) {
        super.init(with: title)
        setTextFieldInputView(datePicker)
        configureDatePicker()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTextFieldInputView(datePicker)
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let targetYear = currentYear - Constants.Dimensions.userAge
        let defaultDate = Calendar.current.date(
            from: DateComponents(
                year: targetYear,
                month: Constants.Dimensions.startMonth,
                day: Constants.Dimensions.startDay
            )
        )
        datePicker.date = defaultDate ?? Date()
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    override func closeInputView() {
        dateChanged(datePicker)
        
        super.closeInputView()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Strings.dateFormat
        setTextFieldText(formatter.string(from: datePicker.date))
        
        textFieldSendAction(for: .editingChanged)
    }
}

