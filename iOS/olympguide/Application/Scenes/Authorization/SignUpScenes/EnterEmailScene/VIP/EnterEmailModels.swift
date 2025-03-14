//
//  EnterEmailModels.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

enum EnterEmailModels {
    enum SendCode {
        struct Request {
            let email: String
        }
        
        struct Response {
            var error: Error? = nil
        }
        
        struct ViewModel { }
    }
}
