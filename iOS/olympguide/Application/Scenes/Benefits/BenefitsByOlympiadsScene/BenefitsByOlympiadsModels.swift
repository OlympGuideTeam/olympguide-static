//
//  BenefitsModels.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
enum BenefitsByOlympiads {
    enum Load {
        struct Request {
            let programID: Int
            let params: [ParamType: SingleOrMultipleArray<Param>]
        }
        
        struct Response {
            var error: Error? = nil
            var olympiads: [OlympiadWithBenefitsModel]? = nil
        }
        
        struct ViewModel {
            let benefits: [OlympiadWithBenefitViewModel]
        }
    }
}
