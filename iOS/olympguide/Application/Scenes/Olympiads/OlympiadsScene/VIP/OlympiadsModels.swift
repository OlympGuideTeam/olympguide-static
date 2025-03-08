//
//  OlympiadsModels.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

// MARK: - Main screen: Olympiads
enum Olympiads {
    
    // MARK: - Use Cases
    enum Load {
        struct Request {
            let params: Dictionary<ParamType, SingleOrMultipleArray<Param>>
        }
        
        struct Response {
            let olympiads: [OlympiadModel]
        }
        
        struct ViewModel {
            let olympiads: [OlympiadViewModel]
        }
    }
    
    // MARK: - Sorting options
    enum SortOption: String {
        case name
        case popularity
        case level
    }
}
