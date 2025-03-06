//
//  ProgramWithBenefitsViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramWithBenefitsViewModel {
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
