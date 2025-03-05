//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

final class OlympiadInteractor {
    var presenter: (OlympiadPresentationLogic & BenefitsByProgramsPresentationLogic)?
    var worker: (OlympiadWorkerLogic & BenefitsByProgramsWorkerLogic)?
    var universities: [UniversityModel]?
    var programs: [ProgramWithBenefitsModel]?
}

extension OlympiadInteractor : OlympiadBusinessLogic {
    func loadUniversities(with request: Olympiad.LoadUniversities.Request) {
        worker?.fetchUniversities(
            for: request.olympiadID
        ) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
                let response = Olympiad.LoadUniversities.Response(universities: universities)
                self?.presenter?.presentLoadUniversities(with: response)
            case .failure(let error):
                let response = Olympiad.LoadUniversities.Response(error: error)
                self?.presenter?.presentLoadUniversities(with: response)
            }
        }
    }
}

extension OlympiadInteractor : BenefitsByProgramsBusinessLogic {
    func loadBenefits(with request: BenefitsByPrograms.Load.Request) {
        worker?.fetchBenefits(
            for: request.olympiadID,
            and: request.universityID,
            with: request.params
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                self?.programs = programs
                let response = BenefitsByPrograms.Load.Response(programs: programs, section: request.section)
                self?.presenter?.presentLoadBenefits(with: response)
            case .failure(let error):
                let response = BenefitsByPrograms.Load.Response(error: error)
                self?.presenter?.presentLoadBenefits(with: response)
            }
        }
    }
}

