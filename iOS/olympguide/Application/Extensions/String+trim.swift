//
//  String+trim.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespaces)
    }
}
