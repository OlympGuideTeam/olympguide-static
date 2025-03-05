//
//  BenefitStackView.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import UIKit

struct BenefitInfo {
    let title: String
    let description: String
}

final class BenefitStackView: UIStackView {
    var benefitInfo: BenefitInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
}

extension BenefitStackView: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        
      
        let identifier = NSString(string: "BenefitStackViewPreview")
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: { [weak self] in
                guard
                    let self = self,
                      let info = self.benefitInfo
                else { return nil }
                
                let previewVC = BenefitByProgramViewController(with: info)
                
                previewVC.preferredContentSize = CGSize(width: 0, height: 300)
                
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
//        animator.addCompletion { [weak self] in
//            guard let self = self,
//                  let info = self.benefitInfo else { return }
//            
//            // Создаем полноценный VC. Можно тот же, что и в previewProvider,
//            // а можно новый экземпляр (обычно так и делают).
//            let detailVC = BenefitByProgramViewController(with: info)
//            
//            // Находим ближайший UIViewController в иерархии (чтобы пушить/презентовать)
//            guard let parentVC = self.findViewController() else { return }
//            detailVC.modalPresentationStyle = .pageSheet
//            if let sheet = detailVC.sheetPresentationController {
//                sheet.detents = [.medium(), .large()]
//                sheet.selectedDetentIdentifier = .medium
//            }
//            
//            parentVC.present(detailVC, animated: true)
//        }
    }
    
    func openPage() {
        guard let info = self.benefitInfo else { return }
        let detailVC = BenefitByProgramViewController(with: info)
        
        guard let parentVC = self.findViewController() else { return }
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
        }
        
        parentVC.present(detailVC, animated: true)
    }
}

final class BenefitByProgramViewController: UIViewController {
    init(with info: BenefitInfo) {
        super.init(nibName: nil, bundle: nil)
        title = info.description
        view.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
