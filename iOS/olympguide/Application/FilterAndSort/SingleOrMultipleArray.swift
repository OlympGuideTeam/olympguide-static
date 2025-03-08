//
//  SingleOrMultipleArray.swift
//  olympguide
//
//  Created by Tom Tim on 08.03.2025.
//

struct SingleOrMultipleArray<Element> {
    private class Storage {
        var elements: [Element]
        init(elements: [Element] = []) {
            self.elements = elements
        }
    }
    
    private var storage: Storage
    private let isMultiple: Bool
    
    init(isMultiple: Bool) {
        self.isMultiple = isMultiple
        self.storage = Storage()
    }
    
    private mutating func ensureUniqueStorage() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(elements: storage.elements)
        }
    }
    
    mutating func add(_ element: Element) {
        ensureUniqueStorage()
        if isMultiple {
            storage.elements.append(element)
        } else {
            storage.elements = [element]
        }
    }
    
    mutating func remove(_ element: Element) where Element: Equatable {
        ensureUniqueStorage()
        if isMultiple {
            storage.elements.removeAll { $0 == element }
        } else {
            storage.elements.removeAll()
        }
    }
    
    mutating func remove(at index: Int) {
        ensureUniqueStorage()
        guard index >= 0 && index < storage.elements.count else { return }
        if isMultiple {
            storage.elements.remove(at: index)
        } else {
            storage.elements.removeAll()
        }
    }
    
    mutating func clear() {
        ensureUniqueStorage()
        storage.elements.removeAll()
    }
    
    var array: [Element] {
        return storage.elements
    }
}
