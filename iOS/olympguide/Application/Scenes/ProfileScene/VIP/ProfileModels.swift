//
//  ProfileModels.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 23.04.2025.
//

enum Profile {
    enum User {
        struct Request { }
        struct Response {
            var user: UserModel? = nil
            var error: Error? = nil
        }
        struct ViewModel {
            let user: UserViewModel
        }
    }
}

struct UserModel: Codable {
    struct RegionModel : Codable{
        let regionId: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case regionId = "region_id"
            case name
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
        guard let region else {
            return UserViewModel(
                firstName: self.firstName,
                lastName: self.lastName,
                secondName: self.secondName,
                birthday: self.birthday,
                region: nil
            )
        }

        return UserViewModel(
            firstName: self.firstName,
            lastName: self.lastName,
            secondName: self.secondName,
            birthday: self.birthday,
            region: UserViewModel.RegionModel(
                regionId: region.regionId,
                name: region.name
            )
        )
    }
}

struct UserViewModel {
    struct RegionModel {
        let regionId: Int
        let name: String
    }
    
    let firstName: String?
    let lastName: String?
    let secondName: String?
    let birthday: String?
    let region: RegionModel?
}

