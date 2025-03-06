//
//  Program.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
enum Program {
    enum Favorite {
        struct Request {
            let programID: Int
            let isFavorite: Bool
        }
        
        struct Response {
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    enum Load {
        struct Request {
            let programID: Int
        }
        
        struct Response {
            var error: Error? = nil
            var program: ProgramModel? = nil
        }
        
        struct ViewModel {
            let program: ProgramShortModel
        }
    }
}
