//
//  DirectionsModels.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

enum Programs {
    enum Load {
        struct Request {
            let params: [ParamType: SingleOrMultipleArray<Param>]
            let university: UniversityModel?
            var groups: Groups = .fields
        }
        
        struct Response {
            var groupsOfPrograms: [GroupOfProgramsModel]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            let groupsOfPrograms: [GroupOfProgramsViewModel]
        }
    }
}
