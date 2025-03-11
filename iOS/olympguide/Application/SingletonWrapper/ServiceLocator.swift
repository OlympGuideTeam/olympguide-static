//
//  ServiceLocator.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

protocol ServiceLocatorProtocol {
    func register<S>(service: S)
    func resolve<S>(type: S.Type) -> S
}

final class ServiceLocator : ServiceLocatorProtocol {
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() { }
    
    func register<T>(service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }
    
    func resolve<T>(type: T.Type) -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("Service of type \(T.self) is not registered.")
        }
        return service
    }
}
