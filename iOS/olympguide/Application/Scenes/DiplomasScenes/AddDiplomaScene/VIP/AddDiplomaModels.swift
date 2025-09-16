//
//  AddDiplomamodels.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

enum AddDiploma {
    struct Request {
        let diplomaClass: Int?
        let diplomaLevel: Int?
    }
    
    struct Response {
        var error: Error?
    }
    
    struct ViewModel { }
}
