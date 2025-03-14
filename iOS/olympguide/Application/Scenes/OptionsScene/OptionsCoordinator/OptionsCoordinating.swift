//
//  OptionsCoordinating.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

protocol OptionsCoordinating: AnyObject {
    func presentOptions(
        on presentingVC: UIViewController,
        contentVC: UIViewController,
        completion: (() -> Void)?
    )

    func dismissOptions(completion: (() -> Void)?)
}
