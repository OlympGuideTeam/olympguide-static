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
    func routeToPersonalData()
}

protocol ProfileBusinessLogic {
    func loadUser(with request: Profile.User.Request)
}

protocol ProfilePresentationLogic {
    func presentUser(with response: Profile.User.Response)
}

protocol ProfileDisplayLogic : AnyObject {
    func displayLoadUser(with viewModel: Profile.User.ViewModel)
}

protocol ProfileDataStore {
    var user: UserModel? { get }
}


protocol ProfileDataPassingLogic {
    var dataStore: ProfileDataStore? { get }
}

