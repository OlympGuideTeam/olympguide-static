//
//  OlympiadModels.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

enum Olympiad {
    enum LoadUniversities {
        struct Request {
            let olympiadID: Int
        }
        
        struct Response {
            var universities: [UniversityModel]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            let universities: [UniversityViewModel]
        }
    }
}
