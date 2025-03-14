//
//  String+Slice.swift
//  olympguide
//
//  Created by Tom Tim on 09.03.2025.
//

extension String {
    func slice(from start: Int, to end: Int) -> String? {
        guard start >= 0, end < count, start <= end else { return nil }
        let startIndex = index(self.startIndex, offsetBy: start)
        let endIndex = index(self.startIndex, offsetBy: end + 1)
        return String(self[startIndex..<endIndex])
    }
    
    func slice(from start: Int) -> String? {
        guard start >= 0, start < count else { return nil }
        let startIndex = index(self.startIndex, offsetBy: start)
        return String(self[startIndex...])
    }
    
    func slice(to end: Int) -> String? {
        guard end >= 0, end < count else { return nil }
        let endIndex = index(self.startIndex, offsetBy: end + 1)
        return String(self[..<endIndex])
    }
    
    func char(at index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
