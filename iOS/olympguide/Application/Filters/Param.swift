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
