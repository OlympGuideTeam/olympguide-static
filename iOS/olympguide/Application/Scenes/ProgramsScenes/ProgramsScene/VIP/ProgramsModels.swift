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
            let groupsOfPrograms: [GroupOfProgramsModel]?
            let error: Error?
        }
        
        struct ViewModel {
            struct GroupOfProgramsViewModel {
                let name: String
                let code: String
                var isExpanded: Bool = false
                
                var programs: [ProgramViewModel]
            }
            
            let groupsOfPrograms: [GroupOfProgramsViewModel]
        }
    }
}
