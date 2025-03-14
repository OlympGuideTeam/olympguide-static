//
//  InjectSingleton.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

@propertyWrapper
struct InjectSingleton<T> {
    private var instance: T
    
    init() {
        self.instance = ServiceLocator.shared.resolve(type: T.self)
    }
    
    init(mock: T) {
        self.instance = mock
    }
    
    var wrappedValue: T {
        get { instance }
        set { instance = newValue }
    }
}
