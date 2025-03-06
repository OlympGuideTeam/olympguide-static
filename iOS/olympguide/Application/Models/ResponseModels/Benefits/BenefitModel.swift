//
//  BenefitModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct BenefitModel : Codable {
    struct ConfirmationSubject : Codable {
        let subject: String
        let score: Int
    }
    
    let minClass: Int
    let minDiplomaLevel: Int
    let isBVI: Bool
    let confirmationSubjects: [ConfirmationSubject]?
    let fullScoreSubjects: [String]?
    
    enum CodingKeys: String, CodingKey {
        case minClass = "min_class"
        case minDiplomaLevel = "min_diploma_level"
        case isBVI = "is_bvi"
        case confirmationSubjects = "confirmation_subjects"
        case fullScoreSubjects = "full_score_subjects"
    }
}
