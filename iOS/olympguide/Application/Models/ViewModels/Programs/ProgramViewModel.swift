//
//  ProgramViewModel.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

struct ProgramViewModel {
    let programID: Int
    let name: String
    let code: String
    let budgetPlaces: Int
    let paidPlaces: Int
    let cost: Int
    var like: Bool
    let requiredSubjects: [String]
    let optionalSubjects: [String]?
}
