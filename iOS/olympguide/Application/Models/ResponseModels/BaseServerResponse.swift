//
//  BaseServerResponse.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

struct BaseServerResponse : Decodable {
    let message: String?
    let type: String?
    let time: Int?
    let token: String?
    
    enum CodingKeys : String, CodingKey {
        case time = "ttl"
        case message, type, token
    }
}
