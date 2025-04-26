//
//  ProfilePresenter.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 23.04.2025.
//

import UIKit

final class ProfilePresenter : ProfilePresentationLogic {
    weak var viewController: (ProfileDisplayLogic & UIViewController)?
    
    func presentUser(with response: Profile.User.Response) {
        if let error = response.error {
//            viewController?.showAlert(with: "Не удалось загрузить данные пользователя")
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let user = response.user?.toViewModel() else {
            return
        }
        let viewModel = Profile.User.ViewModel(user: user)
        viewController?.displayLoadUser(with: viewModel)
    }
}
