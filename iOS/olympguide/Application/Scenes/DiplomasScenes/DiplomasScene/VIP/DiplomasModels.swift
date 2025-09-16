//
//  Models.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

enum Diplomas {
    enum Load {
        struct Request { }
        
        struct Response {
            var diplomas: [DiplomaModel]?
            var error: Error?
        }
        
        struct ViewModel {
            var diplomas: [DiplomaViewModel]
        }
    }
    
    enum Delete {
        struct Request {
            let index: Int
        }
        
        struct Response {
            var error: Error?
        }
        
        struct ViewModel { }
    }
    
    enum Sync {
        struct Request { }
        
        struct Response {
            var error: Error?
        }
    }
}
