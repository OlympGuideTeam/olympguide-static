//
//  UniversityModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct UniversityModel : Codable {
    let email: String?
    let site: String?
    let description: String?
    let phone: String?
    
    let universityID: Int
    let name: String
    let shortName: String
    let logo: String
    let region: String
    // TODO: - Why there is optional?...
    var like: Bool?
    
    enum CodingKeys : String, CodingKey {
        case universityID = "university_id"
        case shortName = "short_name"
        case name, logo, region, like, email, site, description, phone
    }
    
    func toViewModel() -> UniversityViewModel {
        UniversityViewModel(
            universityID: universityID,
            name: name,
            logoURL: logo,
            region: region,
            like: like ?? false
        )
    }
}
