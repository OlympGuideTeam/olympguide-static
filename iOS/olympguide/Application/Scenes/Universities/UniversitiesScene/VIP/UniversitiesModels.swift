//
//  UniversitiesModels.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - Main screen: Universities
enum Universities {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let params: Dictionary<String, Set<String>>
        }
        
        struct Response {
            let universities: [UniversityModel]
        }
        
        struct ViewModel {
            let universities: [UniversityViewModel]
        }
    }
    
    enum Favorite {
        struct Request {
            let universityID: Int
            let isFavorite: Bool
        }
        
        struct Response {
            let error: Error?
        }
        
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    // MARK: - Sorting options
    enum SortOption: String {
        case name
        case popularity
    }
}
