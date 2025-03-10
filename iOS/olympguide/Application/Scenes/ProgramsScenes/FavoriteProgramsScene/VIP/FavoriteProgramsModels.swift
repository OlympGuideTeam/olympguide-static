//
//  Models.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

enum FavoritePrograms {
    enum Load {
        struct Request {
        }
        
        struct Response {
            var error: Error? = nil
            var programs: [ProgramsByUniversityModel]? = nil
        }
        
        struct ViewModel {
            let programs: [ProgramsByUniversityViewModel]
        }
    }
}
