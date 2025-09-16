//
//  AuthManagerProtocol.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit
import Combine

protocol AuthManagerProtocol {
    var isAuthenticatedPublisher: AnyPublisher<Bool, Never> { get }
    var isAuthenticated: Bool { get set }
    var userEmail: String? { get set }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
    
    func checkSession()
    
    func logout(completion: ((Result<BaseServerResponse, NetworkError>) -> Void)?)
    
    func googleSignIn(
        view: UIViewController,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
    
    func deleteAccount(
        completion: @escaping ((Result<BaseServerResponse, NetworkError>) -> Void)
    )
    
    func appleSignIn(
        token: String,
        completion: @escaping ((Result<BaseServerResponse, NetworkError>) -> Void)
    )
}

