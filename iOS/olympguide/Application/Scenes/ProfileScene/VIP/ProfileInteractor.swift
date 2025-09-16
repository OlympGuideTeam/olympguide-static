//
//  ProfileInteractor.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 23.04.2025.
//

final class ProfileInteractor : ProfileBusinessLogic, ProfileDataStore {
    var user: UserModel?
    var worker: ProfileWorkerLogic?
    var presenter: ProfilePresentationLogic?
    
    func loadUser(with request: Profile.User.Request) {
        worker?.fetchUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                let response  = Profile.User.Response(user: user)
                self?.presenter?.presentUser(with: response)
            case .failure(let error):
                let response  = Profile.User.Response(error: error)
                self?.presenter?.presentUser(with: response)
            }
        }
    }
}
