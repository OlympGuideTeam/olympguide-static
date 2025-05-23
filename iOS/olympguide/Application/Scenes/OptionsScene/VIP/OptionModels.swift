//
//  OptionModels.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

enum Options {
    enum TextDidChange {
        struct Request {
            let query: String
        }
        struct Response {
            struct Dependencies {
                let realIndex: Int
                let currentIndex: Int
            }
            
            let options: [Dependencies]
        }
        struct ViewModel {
            struct DependenciesViewModel {
                let realIndex: Int
                let currentIndex: Int
            }
            
            let dependencies: [DependenciesViewModel]
        }
    }
    
    enum FetchOptions {
        struct Request {
            let endPoint: String
        }
        
        struct Response {
            var options: [DynamicOption]? = nil
            var error: Error? = nil
        }
        
        struct ViewModel {
            var options: [OptionViewModel]? = nil
            var error: Error? = nil
        }
    }
}

struct OptionViewModel {
    let id: Int
    let name: String
}


struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

struct DynamicOption: Decodable {
    let id: Int
    let name: String
    
    static var pseudoID: Int = 0 {
        didSet {
            if pseudoID < 0 { pseudoID = 0 }
        }
    }
    
    static func nextID() -> Int {
        pseudoID += 1
        return pseudoID
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicCodingKeys.self) {
            var idValue: Int?
            var nameValue: String?
            
            for key in container.allKeys {
                if key.stringValue == "name" {
                    nameValue = try container.decode(String.self, forKey: key)
                } else if key.stringValue.hasSuffix("_id") {
                    idValue = try container.decode(Int.self, forKey: key)
                }
            }
            
            if let id = idValue, let name = nameValue {
                self.id = id
                self.name = name
                return
            }
        }
        
        let singleValueContainer = try decoder.singleValueContainer()
        let name = try singleValueContainer.decode(String.self)
        self.name = name
        self.id = DynamicOption.nextID()
    }
}

