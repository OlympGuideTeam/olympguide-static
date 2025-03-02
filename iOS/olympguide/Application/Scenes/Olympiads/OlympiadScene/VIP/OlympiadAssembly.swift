//
//  OlympiadAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

final class OlympiadAssembly {
    static func build(with olympiad: OlympiadModel) -> UIViewController {
        OlympiadViewController(with: olympiad)
    }
}
