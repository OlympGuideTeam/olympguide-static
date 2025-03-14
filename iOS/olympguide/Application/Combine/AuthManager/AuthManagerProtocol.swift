//
//  AuthManagerProtocol.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import Foundation
import Combine

protocol AuthManagerProtocol {
    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> { get }
    var isAuthenticated: Bool { get }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
    
    func checkSession()
    
    func logout(completion: ((Result<BaseServerResponse, NetworkError>) -> Void)?)
}

