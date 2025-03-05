//
//  UIView+FindViewController.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import UIKit

// MARK: - Утилита для поиска UIViewController через UIResponder chain
extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController {
                return vc
            }
            responder = r.next
        }
        return nil
    }
}
