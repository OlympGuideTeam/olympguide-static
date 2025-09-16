//
//  DiplomaInteractor.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

final class DiplomaInteractor : DiplomaBusinessLogic, DiplomaDataStore {
    var presenter: (DiplomaPresentationLogic & BenefitsByProgramsPresentationLogic)?
    var worker: DiplomaWorker = DiplomaWorker()
    
    var diploma: DiplomaModel?
    var programs: [[ProgramWithBenefitsModel]]?
    var universities: [UniversityModel]?
    var allUniversities: [UniversityModel]?

    func loadUniversities(with request: Diploma.LoadUniversities.Request) {
        guard let diploma = diploma else { return }
        
        worker.fetchUniversities(
            for: diploma.id
        ) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
                if self?.allUniversities == nil {
                    self?.allUniversities = universities
                }
                self?.programs = [[ProgramWithBenefitsModel]] (repeating: [], count: universities.count)
                let response = Diploma.LoadUniversities.Response(universities: universities)
                self?.presenter?.presentLoadUniversities(with: response)
            case .failure(let error):
                let response = Diploma.LoadUniversities.Response(error: error)
                self?.presenter?.presentLoadUniversities(with: response)
            }
        }
    }
}

extension DiplomaInteractor : BenefitsByProgramsBusinessLogic {
    func loadBenefits(with request: BenefitsByPrograms.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        guard let diplomaId = diploma?.id else { return }
        worker.fetchBenefits(
            for: diplomaId,
            and: request.universityID,
            with: params
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                self?.programs?[request.section] = programs ?? []
                let response = BenefitsByPrograms.Load.Response(programs: programs ?? [], section: request.section)
                self?.presenter?.presentLoadBenefits(with: response)
            case .failure(let error):
                let response = BenefitsByPrograms.Load.Response(error: error)
                self?.presenter?.presentLoadBenefits(with: response)
            }
        }
    }
}
