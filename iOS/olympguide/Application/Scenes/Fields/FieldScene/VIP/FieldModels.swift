//
//  Models.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

enum Field {
    enum LoadPrograms {
        struct Request {
            let fieldID: Int
            let params: [ParamType: SingleOrMultipleArray<Param>]
        }
        
        struct Response {
            var programs: [ProgramsByUniversityModel]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            let programs: [ProgramsByUniversityViewModel]
        }
    }
}
