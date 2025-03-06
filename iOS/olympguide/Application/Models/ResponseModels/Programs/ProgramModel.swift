//
//  ProgramModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramModel : Codable {
    let programID: Int
    let name: String
    let field: String
    let budgetPlaces: Int
    let paidPlaces: Int
    let cost: Int
    let requiredSubjects: [String]
    let optionalSubjects: [String]
    var like: Bool
    let university: UniversityModel
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case programID = "program_id"
        case budgetPlaces = "budget_places"
        case paidPlaces = "paid_places"
        case requiredSubjects = "required_subjects"
        case optionalSubjects = "optional_subjects"
        case name, field, cost, like, link, university
    }
}
