//
//  BenefitsByProgramsModels.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import Foundation

enum BenefitsByPrograms {
    enum Load {
        struct Request {
            let olympiadID: Int
            let universityID: Int
            let section: Int
            var params: [Param] = []
        }
        
        struct Response {
            var error: Error? = nil
            var programs: [ProgramWithBenefitsModel]? = nil
            var section: Int? = nil
        }
        
        struct ViewModel {
            struct BenefitViewModel {
                struct Program {
                    let programID: Int
                    let programName: String
                    let field: String
                    let university: String
                }
                
                struct BenefitInformationViewModel {
                    let minClass: Int
                    let minDiplomaLevel: Int
                    let isBVI: Bool
                    
                    let confirmationSubjects: [BenefitModel.ConfirmationSubject]?
                    let fullScoreSubjects: [String]?
                }
                
                let program: Program
                let benefitInformation: [BenefitInformationViewModel]
            }
            
            let benefits: [BenefitViewModel]
            let section: Int
        }
    }
}

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
