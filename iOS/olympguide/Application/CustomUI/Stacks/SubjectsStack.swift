//
//  SubjectsStack.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class SubjectsStack: UIStackView {
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 10
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(requiredSubjects: [String], optionalSubjects: [String]){
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for subject in requiredSubjects {
            if let subject = Subject(rawValue: subject) {
                let subjectsLabel = SubjectLabel(
                    text: subject.abbreviation,
                    side: .Single
                )
                addArrangedSubview(subjectsLabel)
            }
        }
        
        if !optionalSubjects.isEmpty {
            let optionalSubjectsStack = OptionalSubjectsStack(subjects: optionalSubjects)
            addArrangedSubview(optionalSubjectsStack)
        }
        setHeight(34)
    }
}

enum Subject {
    case Russian
    case English
    case Math
    case Physics
    case Chemistry
    case History
    case Biology
    case SocialStudies
    case Informatics
    case Geographie
    case Literature
    
    init?(rawValue: String) {
        switch rawValue {
        case "Русский язык":
            self = .Russian
        case "Иностранный язык":
            self = .English
        case "Математика":
            self = .Math
        case "Физика":
            self = .Physics
        case "Химия":
            self = .Chemistry
        case "История":
            self = .History
        case "Биология":
            self = .Biology
        case "Обществознание":
            self = .SocialStudies
        case "Информатика":
            self = .Informatics
        case "География":
            self = .Geographie
        case "Литература":
            self = .Literature
        default:
            return nil
        }
    }
    
    var abbreviation: String {
        switch self {
        case .Russian: return "Рус."
        case .English: return "Ин.Яз."
        case .Math: return "Мат."
        case .Physics: return "Физ."
        case .Chemistry: return "Хим."
        case .History: return "Ист."
        case .Biology: return "Биол."
        case .SocialStudies: return "Общ."
        case .Informatics: return "Инф."
        case .Geographie: return "Геог."
        case .Literature: return "Лит."
        }
    }
//    var abbreviation: String {
//        switch self {
//        case .Russian: return "РЯ"
//        case .English: return "ИЯ"
//        case .Math: return "М"
//        case .Physics: return "Ф"
//        case .Chemistry: return "Х"
//        case .History: return "И"
//        case .Biology: return "Б"
//        case .SocialStudies: return "О"
//        case .Informatics: return "ИКТ"
//        case .Geographie: return "Г"
//        case .Literature: return "Л"
//        }
//    }
}
