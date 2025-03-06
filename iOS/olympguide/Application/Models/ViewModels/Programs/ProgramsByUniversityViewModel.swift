//
//  ProgramsByUniversityViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramsByUniversityViewModel {
    let university: UniversityViewModel
    let programs: [ProgramViewModel]
    var isExpanded: Bool = false
}
