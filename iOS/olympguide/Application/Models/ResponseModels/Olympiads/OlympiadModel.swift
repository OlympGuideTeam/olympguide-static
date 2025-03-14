//
//  OlympiadModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct OlympiadModel : Codable {
    let olympiadID: Int
    let name: String
    let level: Int
    let profile: String
    var like: Bool
    
    enum CodingKeys: String, CodingKey {
        case olympiadID = "olympiad_id"
        case name, profile, level, like
    }
    
    func toViewModel() -> OlympiadViewModel {
        OlympiadViewModel(
            olympiadId: olympiadID,
            name: name,
            profile: profile,
            level: String(repeating: "I", count: level),
            like: like
        )
    }
}
