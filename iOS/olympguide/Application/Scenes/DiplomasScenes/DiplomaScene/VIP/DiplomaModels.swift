//
//  DiplomaModels.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

enum Diploma {
    enum LoadUniversities {
        struct Request { }
        
        struct Response {
            var universities: [UniversityModel]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            let universities: [UniversityViewModel]
        }
    }
}
