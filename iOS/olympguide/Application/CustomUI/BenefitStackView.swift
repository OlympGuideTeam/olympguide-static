//
//  BenefitStackView.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import UIKit

final class BenefitStackView: UIStackView {
    weak var parentCell: UIProgramWithBenefitsCell?
    var createPreviewVC: ((_: IndexPath, _ : Int) -> UIViewController?)?
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(openDetailsVC)
        )
        addGestureRecognizer(tapGesture)
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BenefitStackView: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let indexPath = self.indexPath else { return nil }
        return UIContextMenuConfiguration(
            previewProvider: { [weak self] in
                guard
                    let self = self
                else { return nil }
                
                let previewVC = createPreviewVC?(indexPath, tag)
                
                return previewVC
            },
            actionProvider: { _ in
                return nil
            }
        )
    }
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        animator.addCompletion { [weak self] in
            guard
                let self = self,
                let indexPath = self.indexPath,
                let detailVC = createPreviewVC?(indexPath, tag),
                let parentVC = self.findViewController()
            else { return }
            
            parentVC.present(detailVC, animated: true)
        }
    }
    
    @objc func openDetailsVC() {
        guard
            let indexPath = self.indexPath,
            let detailVC = createPreviewVC?(indexPath, tag),
            let parentVC = self.findViewController()
        else { return }
        
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
        }
        
        parentVC.present(detailVC, animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentCell?.shouldIgnoreHighlight = true
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentCell?.shouldIgnoreHighlight = false
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentCell?.shouldIgnoreHighlight = false
        super.touchesCancelled(touches, with: event)
    }
}
