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

struct Model : Codable {
    //    let olympiadID: Int
    //    enum CodingKeys: String, CodingKey {
    //        case olympiadID = "olympiad_id"
    //        case name, profile, level, like
    //    }
}
