//
//  Param.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation


enum ParamType: String {
    case sort
    case region
    case olympiadLevel = "level"
    case olympiadProfile = "profile"
    case degree
    case subject
    case minClass = "min_class"
    case benefit = "is_bvi"
    case minDiplomaLevel = "min_diploma_level"
}

struct Param {
    let paramType: ParamType
    let value: String
    
    var urlValue: URLQueryItem {
        URLQueryItem(name: paramType.rawValue, value: self.value)
    }
    
    
    init?(paramType: ParamType, option: OptionViewModel) {
        self.paramType = paramType
        
        switch paramType {
        case .olympiadLevel, .minDiplomaLevel, .minClass:
            self.value = String(option.id)
        case .sort:
            switch option.name {
            case "По уровню", "По уровню олимпиады":
                self.value = "level"
            case "По профилю", "По профилю олимпиады":
                self.value = "profile"
            case "По имени":
                self.value = "name"
            default:
                return nil
            }
        case .benefit:
            if option.name == "БВИ" {
                self.value = "true"
            } else {
                self.value = "false"
            }
        default:
            self.value = option.name
        }
    }
}

//enum Paramm {
//    case level(Int)
//    case diplomaClass(Int)
//    case region(Int)
//    case unknown(String, String)
//    
//    init?(_ param_name: String, _ param_value: Any) {
//        switch param_name {
//            case "level":
//            if let value = param_value as? Int {
//                self = .level(value)
//                return
//            }
//        case "diploma_class":
//            if let value = param_value as? Int {
//                self = .diplomaClass(value)
//                return
//            }
//        case "region":
//            if let value = param_value as? Int {
//                self = .region(value)
//                return
//            }
//        default:
//            if let value = param_value as? CustomStringConvertible {
//                self = .unknown(param_name, value.description)
//                return
//            }
//        }
//        return nil
//    }
//    
//    var key: String {
//        switch self {
//        case .level:
//            return "level"
//        case .diplomaClass:
//            return "class"
//        case .region:
//            return "region"
//        case .unknown(let key, _):
//            return key
//        }
//    }
//    
//    var value: String {
//        switch self {
//        case .level(let value):
//            return String(value)
//        case .diplomaClass(let value):
//            return String(value)
//        case .region(let value):
//            return String(value)
//        case .unknown(_, let value):
//            return value
//        }
//    }
//    
//    var urlValue: URLQueryItem {
//        URLQueryItem(name: self.key, value: self.value)
//    }
//}
