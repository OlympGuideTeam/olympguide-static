//
//  PersonalDataModels.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

enum PersonalData {
    enum SignUp {
        struct Request {
            let token: String?
            let password: String?
            let firstName: String?
            let lastName: String?
            let secondName: String?
            let birthday: String?
            let regionId: Int?
            var isGoogleSignUp: Bool = false
        }
        
        struct Response {
            var error: Error? = nil
        }
        
        struct ViewModel {
            let errorMessage: [String]?
        }
    }
}
