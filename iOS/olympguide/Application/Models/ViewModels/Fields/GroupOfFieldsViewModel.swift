//
//  GroupOfFieldsViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

class GroupOfFieldsViewModel {
    var isExpanded: Bool = false
    
    let mainField: FieldViewModel
    let fields: [FieldViewModel]
    
    init(isExpanded: Bool = false, mainField: FieldViewModel, fields: [FieldViewModel]) {
        self.isExpanded = isExpanded
        self.mainField = mainField
        self.fields = fields
    }
}
class FieldViewModel {
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
