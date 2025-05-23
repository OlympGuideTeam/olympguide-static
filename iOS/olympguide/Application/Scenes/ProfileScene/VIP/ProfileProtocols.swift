//
//  ProfileProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

// MARK: - Routing Logic
protocol ProfileRoutingLogic {
    func routeToSignIn()
    func routeToSignUp()
    func routToAboutUs()
    func routToFavoriteOlympiads()
    func routToFavoriteUniversities()
    func routToFavoritePrograms()
    func routeToDiplomas()
    func routeToGoogleSignIn(with token: String)
}

protocol ProfileBusinessLogic {
    func googleSignIn()
}

