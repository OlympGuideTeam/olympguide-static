//
//  ProgramWithBenefitsSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class ProgramWithBenefitsSearchStrategy: SearchStrategy {
    typealias ModelType = ProgramWithBenefitsModel
    typealias ViewModelType = ProgramWithBenefitsViewModel
    typealias ResponseType = ProgramWithBenefitsModel
    
    var allUniversities: [UniversityModel]?
    var viewModels: [ViewModelType]?
    
    static var searchTitle: String = "Поиск по программам"
    
    func endpoint() -> String {
        ""
    }
    
    func queryItems(for query: String) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "search", value: query.trim()))
        return queryItems
    }
    
    func registerCells(in tableView: UITableView) {
        tableView.register(
            UIProgramWithBenefitsCell.self,
            forCellReuseIdentifier: UIProgramWithBenefitsCell.identifier
        )
    }
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: ProgramWithBenefitsViewModel,
        isSeparatorHidden: Bool
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UIProgramWithBenefitsCell.identifier,
            for: indexPath
        ) as? UIProgramWithBenefitsCell else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: viewMmodel, indexPath: indexPath)
        
        for view in cell.benefitsStack.arrangedSubviews {
            guard let subview = view as? BenefitStackView else { continue }
            subview.createPreviewVC = { [weak self] indexPath, index in
                guard let self = self else { return nil }
                guard let program = self.viewModels?[indexPath.row] else { return nil }
                let previewVC = BenefitViewController(with: program, index: index)
                return previewVC
            }
        }
        
        cell.hideSeparator(isSeparatorHidden)
        return cell
    }
    
    func titleForItem(_ model: ProgramWithBenefitsModel) -> String {
        model.program.name
    }
    
    func responseTypeToModel(
        _ response: [ProgramWithBenefitsModel]
    ) -> [ProgramWithBenefitsModel] {
         response
    }
    
    func modelToViewModel(
        _ model: [ProgramWithBenefitsModel]
    ) -> [ProgramWithBenefitsViewModel] {
        self.viewModels =  model.map { $0.toViewModel() }
        return viewModels ?? []
    }
    
    func build(with model: ProgramWithBenefitsModel) -> (UIViewController?, PresentMethod?) {
        guard let allUniversities = allUniversities else {
            return (nil, nil)
        }
        
        let universityId = model.program.universityID
        guard
            let index = allUniversities.firstIndex(where: { $0.universityID == universityId})
        else {
            return (nil, nil)
        }
        
        let university = allUniversities[index]
        let programId = model.program.programID
        let name = model.program.name
        let code = model.program.field
        
        let programVC = ProgramAssembly.build(
            for: programId,
            name: name,
            code: code,
            university: university
        )
        return (programVC, .push)
    }
}
