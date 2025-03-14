//
//  ProgramsByUniversityViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

class ProgramsByUniversityViewModel {
    let university: UniversityViewModel
    var programs: [ProgramViewModel]
    var isExpanded: Bool = false
    
    init(
        university: UniversityViewModel,
        programs: [ProgramViewModel],
        isExpanded: Bool = false
    ) {
        self.university = university
        self.programs = programs
        self.isExpanded = isExpanded
    }
}
