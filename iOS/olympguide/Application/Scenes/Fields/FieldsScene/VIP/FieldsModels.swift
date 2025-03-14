//
//  FieldsModels.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Main screen: Fields
enum Fields {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let params: Dictionary<ParamType, SingleOrMultipleArray<Param>>
        }
        
        struct Response {
            var groupsOfFields: [GroupOfFieldsModel]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            let groupsOfFields: [GroupOfFieldsViewModel]
        }
    }
}
