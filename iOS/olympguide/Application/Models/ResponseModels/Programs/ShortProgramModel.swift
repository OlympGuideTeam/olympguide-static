//
//  ShortProgramModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ShortProgramModel : Codable {
    let programID: Int
    let name: String
    let field: String
    let budgetPlaces: Int
    let paidPlaces: Int
    let cost: Int
    let requiredSubjects: [String]
    let optionalSubjects: [String]?
    var like: Bool
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case programID = "program_id"
        case budgetPlaces = "budget_places"
        case paidPlaces = "paid_places"
        case name, field, cost, like, link
        case requiredSubjects = "required_subjects"
        case optionalSubjects = "optional_subjects"
    }
}
