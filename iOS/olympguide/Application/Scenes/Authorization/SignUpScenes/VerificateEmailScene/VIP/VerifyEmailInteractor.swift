//
//  EnterEmailInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

final class VerifyEmailInteractor: VerifyEmailBusinessLogic, VerifyEmailDataStore {
    
    // MARK: - External properties
    var presenter: VerifyEmailPresentationLogic?
    var worker: VerifyEmailWorkerLogic = VerifyEmailWorker()
    
    // MARK: - DataStore
    var email: String?
    var time: Int?
    // MARK: - VerifyEmailBusinessLogic
    func verifyCode(with request: VerifyEmailModels.VerifyCode.Request) {
        self.email = request.email
        
        worker.verifyCode(code: request.code, email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let response = VerifyEmailModels.VerifyCode.Response(
                    success: true,
                    error: nil
                )
                self.presenter?.presentVerifyCode(with: response)
                
            case .failure(let networkError):
                let response = VerifyEmailModels.VerifyCode.Response(
                    success: false,
                    error: networkError as NSError
                )
                self.presenter?.presentVerifyCode(with: response)
            }
        }
    }
    
    func resendCode(with request: VerifyEmailModels.ResendCode.Request) {
        self.email = request.email
        
        worker.resendCode(email: request.email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let baseResponse):
                self.time = baseResponse.time
                let response = VerifyEmailModels.ResendCode.Response()
                self.presenter?.presentResendCode(with: response)
                
            case .failure(let networkError):
                switch networkError {
                case .previousCodeNotExpired(let time):
                    self.time = time
                    let response = VerifyEmailModels.ResendCode.Response()
                    self.presenter?.presentResendCode(with: response)
                    
                default:
                    let response = VerifyEmailModels.ResendCode.Response(
                        error: networkError
                    )
                    self.presenter?.presentResendCode(with: response)
                }
            }
        }
    }
}
