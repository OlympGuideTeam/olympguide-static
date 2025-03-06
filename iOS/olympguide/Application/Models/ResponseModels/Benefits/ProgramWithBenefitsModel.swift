//
//  ProgramWithBenefitsModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramWithBenefitsModel : Codable {
    struct Program: Codable {
        let programID: Int
        let name: String
        let field: String
        let university: String
        
        enum CodingKeys: String, CodingKey {
            case programID = "program_id"
            case name, field, university
        }
    }
    
    let program: Program
    let benefits: [BenefitModel]
}
