//
//  PersonalDataInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import Foundation

final class PersonalDataInteractor : PersonalDataBusinessLogic {
    var presenter: PersonalDataPresentationLogic?
    private let worker = PersonalDataWorker()
    
    func signUp(with request: PersonalData.SignUp.Request) {
        guard
            let firstName = request.firstName?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty,
            let lastName = request.lastName?.trimmingCharacters(in: .whitespacesAndNewlines), !lastName.isEmpty,
            let birthday = request.birthday?.trimmingCharacters(in: .whitespacesAndNewlines), !birthday.isEmpty,
            let regionId = request.regionId
        else {
            var validationErrors: [ValidationError] = []
            
            if request.firstName?.isEmpty ?? true {
                validationErrors.append(.invalidFirstName)
            }
            
            if request.lastName?.isEmpty ?? true {
                validationErrors.append(.invalidLastName)
            }
            
            if request.birthday?.isEmpty ?? true {
                validationErrors.append(.invalidBirthay)
            }
            
            if request.regionId == nil {
                validationErrors.append(.invalidRegion)
            }
            
            let response = PersonalData.SignUp.Response(
                error: AppError.validation(validationErrors) as NSError
            )
            
            self.presenter?.presentSignUp(with: response)
            
            return
        }
        
        let secondName = request.secondName ?? ""
        
        guard request.secondName == nil || !secondName.isEmpty else {
            var validationErrors: [ValidationError] = []
            validationErrors.append(.invalidSecondName)
            let response = PersonalData.SignUp.Response(
                error: AppError.validation(validationErrors) as NSError
            )
            self.presenter?.presentSignUp(with: response)
            return
        }
        
        worker.updateProfile(
            firstName: firstName,
            lastName: lastName,
            secondName: secondName,
            birthday: birthday,
            regionId: regionId
        )
        { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let response = PersonalData.SignUp.Response()
                
                self.presenter?.presentSignUp(with: response)
            case .failure(let networkError):
            let response = PersonalData.SignUp.Response(
                    error: AppError.network(networkError) as NSError
                )
                self.presenter?.presentSignUp(with: response)
            }
        }
    }
    
    func isPasswordValid(with password: String?) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z0-9\-_!?]{8,}$"#
        
        guard
            let password = password?.trimmingCharacters(in: .whitespacesAndNewlines),
            !password.isEmpty,
            NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        else {
            return false
        }
        
        return true
    }
    
    func generatePassword(length: Int) -> String {
        guard length >= 3 else {
            return "Пароль должен быть длиной не менее 3 символов"
        }

        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let symbols = "-_?!"

        let allCharacters = lowercase + uppercase + digits + symbols
        var passwordCharacters: [Character] = []

        if let lower = lowercase.randomElement() {
            passwordCharacters.append(lower)
        }
        if let upper = uppercase.randomElement() {
            passwordCharacters.append(upper)
        }
        if let digit = digits.randomElement() {
            passwordCharacters.append(digit)
        }

        let remainingCount = length - passwordCharacters.count
        let allArray = Array(allCharacters)
        for _ in 0..<remainingCount {
            if let randomChar = allArray.randomElement() {
                passwordCharacters.append(randomChar)
            }
        }
        passwordCharacters.shuffle()

        return String(passwordCharacters)
    }
}
