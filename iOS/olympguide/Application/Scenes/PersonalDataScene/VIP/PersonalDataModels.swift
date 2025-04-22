//
//  PersonalDataModels.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

enum PersonalData {
    enum SignUp {
        struct Request {
            let firstName: String?
            let lastName: String?
            let secondName: String?
            let birthday: String?
            let regionId: Int?
        }
        
        struct Response {
            var error: Error? = nil
        }
        
        struct ViewModel {
            let errorMessage: [String]?
        }
    }
    
    enum User {
        struct Request { }
        struct Response {
            let user: UserModel
        }
        struct ViewModel {
            let user: UserModel
        }
    }
}

struct UserModel: Codable {
    struct RegionModel : Codable{
        let regionId: Int
        let neme: String
        
        enum CodingKeys: String, CodingKey {
            case regionId = "region_id"
            case neme
        }
    }
    
    let email: String
    let syncGoogle: Bool
    let syncApple: Bool
    let firstName: String?
    let lastName: String?
    let secondName: String?
    let birthday: String?
    let region: RegionModel?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case secondName = "second_name"
        case syncGoogle = "sync_google"
        case syncApple = "sync_apple"
        case birthday, region, email
    }
    
    func toViewModel() -> UserViewModel {
        return UserViewModel(
            firstName: self.firstName,
            lastName: self.lastName,
            secondName: self.secondName,
            birthday: self.birthday,
            region: self.region?.neme
        )
    }
}

struct UserViewModel {
    let firstName: String?
    let lastName: String?
    let secondName: String?
    let birthday: String?
    let region: String?
}
