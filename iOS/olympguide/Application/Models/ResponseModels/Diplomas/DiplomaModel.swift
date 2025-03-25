//
//  DiplomaModel.swift
//  olympguide
//
//  Created by Tom Tim on 23.03.2025.
//

struct DiplomaModel : Codable {
    let id: Int
    let diplomaClass: Int
    let level: Int
    
    let olympiad: OlympiadShortModel
    
    enum CodingKeys : String, CodingKey {
        case id = "diploma_id"
        case diplomaClass = "class"
        case level, olympiad
    }
    
    func toViewModel() -> DiplomaViewModel {
        return DiplomaViewModel(
            diplomaClass: diplomaClass,
            level: level,
            olympiadName: olympiad.name,
            olympiadLevel: olympiad.level,
            olympiadProfile: olympiad.profile
        )
    }
}
