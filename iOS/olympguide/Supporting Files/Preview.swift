//
//  Preview.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import SwiftUI

struct OlympiadViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let olympiadModel = OlympiadModel(
            olympiadID: 279,
            name: "Отраслевая физико-математическая олимпиада школьников «Росатом»",
            level: 2,
            profile: "математика",
            like: false
        )
        let vc = OlympiadAssembly.build(with: olympiadModel)
        
        return NavigationBarViewController(rootViewController: vc)
    }
    
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

struct FieldViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let field = GroupOfFieldsModel.FieldModel(
            fieldId: 1,
            name: "Программная инженерия и бла бла бла бла чтоб название подлиннее было",
            code: "09.03.04",
            degree: "Бакалавриат"
        )
        
        let vc = FieldViewController(for: field)
        
        return NavigationBarViewController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview {
    FieldViewControllerWrapper()
}
