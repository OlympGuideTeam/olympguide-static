//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation
import Combine

final class ProgramInteractor  {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: (ProgramPresentationLogic & BenefitsByOlympiadsPresentationLogic)?
    var worker: (ProgramWorkerLogic & BenefitsByOlympiadsWorkerLogic)?
    var olympiads: [OlympiadWithBenefitsModel] = []
    var isFavorite: Bool?
    var programId: Int?
    
    init() {
        setupBindings()
    }
}

// MARK: - ProgramBusinessLogic
extension ProgramInteractor : ProgramBusinessLogic {
    func loadProgram(with request: Program.Load.Request) {
        self.programId = request.programID
        worker?.fetchProgram(
            with: request.programID
        ) { [weak self] result in
            switch result {
            case .success(let program):
                let response = Program.Load.Response(program: program)
                self?.presenter?.presentLoadProgram(with: response)
            case .failure(let error):
                let response = Program.Load.Response(error: error)
                self?.presenter?.presentLoadProgram(with: response)
            }
        }
    }
}

// MARK: - BenefitsBusinessLogic
extension ProgramInteractor : BenefitsByOlympiadsBusinessLogic {
    func loadOlympiads(with request: BenefitsByOlympiads.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker?.fetchBenefits(
            for: request.programID,
            with: params
        ) { [weak self] result in
            switch result {
            case .success(let olympiads):
                self?.olympiads = olympiads ?? []
                let response = BenefitsByOlympiads.Load.Response(olympiads: olympiads ?? [])
                self?.presenter?.presentLoadOlympiads(with: response)
            case .failure(let error):
                let response = BenefitsByOlympiads.Load.Response(error: error)
                self?.presenter?.presentLoadOlympiads(with: response)
            }
        }
    }
}

extension ProgramInteractor {
    private func setupBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                guard programId == event.programId else { return }
                switch event {
                case.added:
                    presenter?.presentSetFavorite(to: true)
                case .removed:
                    presenter?.presentSetFavorite(to: false)
                case .error:
                    guard let isFavorite = isFavorite  else { return }
                    presenter?.presentSetFavorite(to: isFavorite)
                case .access(_, let isFavorite):
                    self.isFavorite = isFavorite
                }
            }.store(in: &cancellables)
    }
}

