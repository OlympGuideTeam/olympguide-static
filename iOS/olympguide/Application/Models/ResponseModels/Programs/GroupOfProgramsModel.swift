//
//  GroupOfProgramsModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct GroupOfProgramsModel : Codable {
    let facultyID: Int?
    let groupID: Int?
    let name: String
    let code: String?
    var programs: [ProgramShortModel]
    
    enum CodingKeys: String, CodingKey {
        case facultyID = "faculty_id"
        case groupID = "group_id"
        case name, code, programs
    }
}
