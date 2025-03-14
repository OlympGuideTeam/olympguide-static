//
//  GroupOfFieldsModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct GroupOfFieldsModel : Codable {
    struct FieldModel : Codable {
        let fieldId: Int
        let name: String
        let code: String
        let degree: String
        
        enum CodingKeys: String, CodingKey {
            case fieldId = "field_id"
            case name, code, degree
        }
    }
    
    let name: String
    let code: String
    let fields: [FieldModel]
    
    func toViewModel() -> GroupOfFieldsViewModel {
        GroupOfFieldsViewModel(
            mainField: FieldViewModel(
                name: name,
                code: code
            ),
            fields: fields.map { field in
                FieldViewModel(
                    name: field.name,
                    code: field.code
                )
            }
        )
    }
}
