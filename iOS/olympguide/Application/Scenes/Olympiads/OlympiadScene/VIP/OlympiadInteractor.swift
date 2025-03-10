//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

final class OlympiadInteractor : OlympiadDataStore {
    var presenter: (OlympiadPresentationLogic & BenefitsByProgramsPresentationLogic)?
    var worker: (OlympiadWorkerLogic & BenefitsByProgramsWorkerLogic)?
    var universities: [UniversityModel]?
    var programs: [[ProgramWithBenefitsModel]]?
}

extension OlympiadInteractor : OlympiadBusinessLogic {
    func loadUniversities(with request: Olympiad.LoadUniversities.Request) {
        worker?.fetchUniversities(
            for: request.olympiadID
        ) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
                self?.programs = [[ProgramWithBenefitsModel]] (repeating: [], count: universities.count)
                let response = Olympiad.LoadUniversities.Response(universities: universities)
                self?.presenter?.presentLoadUniversities(with: response)
            case .failure(let error):
                let response = Olympiad.LoadUniversities.Response(error: error)
                self?.presenter?.presentLoadUniversities(with: response)
            }
        }
    }
    
    func favoriteStatusAt(index: Int) -> Bool {
        return universities?[index].like ?? false
    }
    
    func setFavoriteStatus(_ status: Bool, to universityId: Int) {
        if let index = universities?.firstIndex(where: { $0.universityID == universityId }) {
            universities?[index].like = status
        }
    }
    
    func universityModel(at index: Int) -> UniversityModel? {
        universities?[index]
    }
}

extension OlympiadInteractor : BenefitsByProgramsBusinessLogic {
    func loadBenefits(with request: BenefitsByPrograms.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker?.fetchBenefits(
            for: request.olympiadID,
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

