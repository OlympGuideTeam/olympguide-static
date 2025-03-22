//
//  ProgramAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class ProgramAssembly {
    static func build(
        for program: ProgramShortModel,
        by university: UniversityModel
    ) -> UIViewController {
        let viewContoller = ProgramViewController(for: program, by: university)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let worker = ProgramWorker()
        let router = ProgramRouter()
        
        viewContoller.interactor = interactor
        viewContoller.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewContoller
        router.viewController = viewContoller
        
        return viewContoller
    }
    
    static func build(for program: ProgramModel) -> UIViewController {
        let viewContoller = ProgramViewController(for: program)
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let worker = ProgramWorker()
        
        viewContoller.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewContoller
        
        return viewContoller
    }
    
    static func build(
        for programID: Int,
        name: String,
        code: String,
        university: UniversityModel
    ) -> UIViewController {
        let viewContoller = ProgramViewController(
            for: programID,
            name: name,
            code: code,
            university: university
        )
        let interactor = ProgramInteractor()
        let presenter = ProgramPresenter()
        let worker = ProgramWorker()
        let router = ProgramRouter()
        
        viewContoller.interactor = interactor
        viewContoller.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewContoller
        router.viewController = viewContoller
        
        return viewContoller
    }
}
