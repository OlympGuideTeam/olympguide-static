//
//  OptionalSubjectsStack.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

final class OptionalSubjectsStack: UIStackView {
    let subjects: [String]
    
    init(subjects: [String]){
        self.subjects = subjects
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        spacing = 2
        
        for (index, subject) in subjects.enumerated() {
            if let subject = Subject(rawValue: subject) {
                if index == 0 {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Left
                    )
                    addArrangedSubview(subjectsLabel)
                } else if index == subjects.count - 1 {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Right
                    )
                    addArrangedSubview(subjectsLabel)
                } else {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Center
                    )
                    addArrangedSubview(subjectsLabel)
                }
            }
        }
    }
}
