//
//  BenefitsByProgramsModels.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

enum BenefitsByPrograms {
    enum Load {
        struct Request {
            let olympiadID: Int
            let universityID: Int
            let section: Int
            var params: [ParamType: SingleOrMultipleArray<Param>]
        }
        
        struct Response {
            var error: Error? = nil
            var programs: [ProgramWithBenefitsModel]? = nil
            var section: Int? = nil
        }
        
        struct ViewModel {            
            let benefits: [ProgramWithBenefitsViewModel]
            let section: Int
        }
    }
}
