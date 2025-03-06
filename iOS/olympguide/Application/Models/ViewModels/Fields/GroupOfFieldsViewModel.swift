//
//  GroupOfFieldsViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct GroupOfFieldsViewModel {
    struct FieldViewModel {
        let name: String
        let code: String
    }
    
    let name: String
    let code: String
    var isExpanded: Bool = false
    
    let fields: [FieldViewModel]
    var visibleRowCount: Int = 0
}
