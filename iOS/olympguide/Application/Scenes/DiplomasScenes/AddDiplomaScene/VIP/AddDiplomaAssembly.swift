//
//  AddDiplomaAssembly.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

import UIKit

final class AddDiplomaAssembly {
    static func build(with olympiad: OlympiadModel) -> UIViewController {
        AddDiplomaViewController(with: olympiad)
    }
}
