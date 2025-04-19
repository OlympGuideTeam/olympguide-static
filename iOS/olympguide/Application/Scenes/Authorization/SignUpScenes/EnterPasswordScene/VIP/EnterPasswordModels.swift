//
//  Models.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

enum EnterPassword {
    enum SignUp {
        struct Request {
            let email: String
            let password: String
        }
        
        struct Response {
            var error: Error? = nil
        }
        
        struct ViewModel {
        }
    }
}
