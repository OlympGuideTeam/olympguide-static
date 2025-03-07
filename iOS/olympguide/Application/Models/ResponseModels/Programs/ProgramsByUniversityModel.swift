//
//  ProgramsByUniversityModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramsByUniversityModel : Codable {
    let univer: UniversityModel
    var programs: [ProgramShortModel]
    
    func toViewModel() -> ProgramsByUniversityViewModel {
        ProgramsByUniversityViewModel(
            university: univer.toViewModel(),
            programs: programs.map { $0.toViewModel() }
        )
    }
}
