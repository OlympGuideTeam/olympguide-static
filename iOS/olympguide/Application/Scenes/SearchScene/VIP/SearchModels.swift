//
//  SearchModels.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

/// Тип поиска — определяем, по чему мы ищем
enum SearchType {
    case universities
    case olympiads
    case fields
    
    var title: String {
        switch self {
        case .universities: return "Поиск по ВУЗам"
        case .olympiads: return "Поиск по олимпиадам"
        case .fields: return "Поиск по направлениям"
        }
    }
}

enum Search {
    enum TextDidChange {
        struct Request {
            let query: String
        }
        
        struct Response<ResponseModel> {
            let items: [ResponseModel]
        }
        
        struct ViewModel<ViewModel> {
            let items: [ViewModel]
        }
    }
}
