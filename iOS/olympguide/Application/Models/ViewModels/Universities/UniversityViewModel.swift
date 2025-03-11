//
//  UniversityViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct UniversityViewModel {
    let universityID: Int
    let name: String
    let logoURL: String
    let region: String
    var like: Bool
}

extension UniversityModel : Equatable {
    static func == (lhs: UniversityModel, rhs: UniversityModel) -> Bool {
        lhs.universityID == rhs.universityID
    }
    
    static func == (lhs: UniversityModel, rhs: UniversityViewModel) -> Bool {
        lhs.universityID == rhs.universityID
    }
}
