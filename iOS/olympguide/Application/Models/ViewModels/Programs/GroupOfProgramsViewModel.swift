//
//  GroupOfProgramsViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

class GroupOfProgramsViewModel {
    let field: FieldViewModel
    var isExpanded: Bool = false
    
    var programs: [ProgramViewModel]
    
    init(
        field: FieldViewModel,
        isExpanded: Bool = false,
        programs: [ProgramViewModel]
    ) {
        self.field = field
        self.isExpanded = isExpanded
        self.programs = programs
    }
}
