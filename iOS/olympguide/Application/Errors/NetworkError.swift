//
//  NetworkError.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError
    case internalServerError
    case uniqueViolation
    case userNotFound
    case invalidPassword
    case invalidCode
    case unknown(message: String?)
    case previousCodeNotExpired(time: Int)
    
    private static let errorMapping: [String: NetworkError] = [
        "InvalidURL": .invalidURL,
        "NoData": .noData,
        "DecodingError": .decodingError,
        "ServerError": .serverError,
        "InternalServerError": .internalServerError,
        "UniqueViolation": .uniqueViolation,
        "UserNotFound": .userNotFound,
        "InvalidPassword": .invalidPassword,
        "InvalidCode": .invalidCode
    ]
    
    init?(serverType: String, time: Int? = nil, message: String? = nil) {
        if serverType == "PreviousCodeNotExpired" {
            if let time = time {
                self = .previousCodeNotExpired(time: time)
            } else {
                self = .unknown(message: "PreviousCodeNotExpired without time")
            }
        } else if let mappedError = NetworkError.errorMapping[serverType] {
            self = mappedError
        } else {
            self = .unknown(message: message)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data from server"
        case .decodingError:
            return "Error while decoding server response"
        case .serverError:
            return "Потеряна связь с сервером"
        case .previousCodeNotExpired:
            return "Previous code is still valid"
        case .internalServerError:
            return "ААААААА СЕНЯЯ ПОЧИНИИИИИ\n(напишите пожалуйста о произошеддшем нам, мы всё починим...)"
        case .uniqueViolation:
            return "Пользователь с такой почтой уже существует"
        case .userNotFound:
            return "Пользователь с такой почтой не найден"
        case .invalidPassword:
            return "Неверный пароль"
        case .invalidCode:
            return "Неверный код"
        case .unknown(let message):
            return message ?? "Произошла неизвестная ошибка"
        }
    }
}
