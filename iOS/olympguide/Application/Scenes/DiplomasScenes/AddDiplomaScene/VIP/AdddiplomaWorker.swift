//
//  AdddiplomaWorker.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

protocol AddDiplomaWorkerLogic {
    func addDiploma(
        olympiadId: Int,
        diplomaClass: Int,
        diplomaLevel: Int,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

final class AddDiplomaWorker : AddDiplomaWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func addDiploma(
        olympiadId: Int,
        diplomaClass: Int,
        diplomaLevel: Int,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let endpoint = "/user/diploma"
        
        let body: [String: Any] = [
            "olympiad_id": olympiadId,
            "class": diplomaClass,
            "level": diplomaLevel
        ]
        
        networkService.request(
            endpoint: endpoint,
            method: .post,
            queryItems: nil,
            body: body,
            shouldCache: false) { (result: Result<BaseServerResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
