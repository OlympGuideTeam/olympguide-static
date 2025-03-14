//
//  FavoritesManager.swift
//  olympguide
//
//  Created by Tom Tim on 28.02.2025.
//

import Combine
import Foundation

final class FavoritesManager: ObservableObject, FavoritesManagerProtocol {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = FavoritesManager()
    
    @Published private(set) var likedUniversities: Set<Int> = []
    @Published private(set) var unlikedUniversities: Set<Int> = []
    
    @Published private(set) var likedPrograms: Set<Int> = []
    @Published private(set) var unlikedPrograms: Set<Int> = []
    
    @Published private(set) var likedOlympiads: Set<Int> = []
    @Published private(set) var unlikedOlympiads: Set<Int> = []
    
    let universityEventSubject = PassthroughSubject<UniversityFavoriteEvent, Never>()
    let programEventSubject = PassthroughSubject<ProgramFavoriteEvent, Never>()
    let olympiadEventSubject = PassthroughSubject<OlympiadFavoriteEvent, Never>()
    
    enum UniversityFavoriteEvent {
        case added(UniversityModel)
        case removed(Int)
        case error(Int)
        case access(Int, Bool)
        
        var id: Int {
            switch self {
            case .added(let university):
                return university.universityID
            case .removed(let id):
                return id
            case .error(let id):
                return id
            case .access(let id, _):
                return id
            }
        }
    }
    
    enum ProgramFavoriteEvent {
        case added(UniversityModel, ProgramShortModel)
        case removed(Int)
        case error(Int)
        case access(Int, Bool)
        
        var programId: Int {
            switch self {
            case .added(_, let program):
                return program.programID
            case .removed(let id):
                return id
            case .error(let id):
                return id
            case .access(let id, _):
                return id
            }
        }
    }
    
    enum OlympiadFavoriteEvent {
        case added(OlympiadModel)
        case removed(Int)
        case error(Int)
        case access(Int, Bool)
        
        var id: Int {
            switch self {
            case .added(let olympiad):
                return olympiad.olympiadID
            case .removed(let id):
                return id
            case .error(let id):
                return id
            case .access(let id, _):
                return id
            }
        }
    }
    
    enum Subject {
        case University
        case Program
        case Olympiad
    }
    
    private init() {}
}

// MARK: - Universities
extension FavoritesManager {
    func addUniversityToFavorites(model: UniversityModel) {
        let id = model.universityID
        likedUniversities.insert(id)
        unlikedUniversities.remove(id)
        universityEventSubject.send(.added(model))
        
        FavoritesBatcher.shared.addUniversityChange(
            universityID: id,
            isFavorite: true
        )
    }
    
    func removeUniversityFromFavorites(universityID: Int) {
        likedUniversities.remove(universityID)
        unlikedUniversities.insert(universityID)
        universityEventSubject.send(.removed(universityID))
        
        FavoritesBatcher.shared.addUniversityChange(
            universityID: universityID,
            isFavorite: false
        )
    }
    
    func handleBatchError(for id: Int, subject: Subject){
        switch subject {
        case .University:
            likedUniversities.remove(id)
            unlikedUniversities.remove(id)
            universityEventSubject.send(.error(id))
        case .Program:
            likedPrograms.remove(id)
            unlikedPrograms.remove(id)
            programEventSubject.send(.error(id))
        case .Olympiad:
            break
        }
    }
    
    func handleBatchSuccess(for id: Int, isFavorite: Bool , subject: Subject){
        switch subject {
        case .University:
            universityEventSubject.send(.access(id, isFavorite))
        case .Program:
            programEventSubject.send(.access(id, isFavorite))
        case .Olympiad:
            break
        }
    }
    
    func isUniversityFavorited(universityID: Int, serverValue: Bool) -> Bool {
        if serverValue, unlikedUniversities.contains(universityID) {
            return false
        }
        if !serverValue, likedUniversities.contains(universityID) {
            return true
        }
        return serverValue
    }
}


// MARK: - Programs
extension FavoritesManager {
    func addProgramToFavorites(_ univer: UniversityModel, _ program: ProgramShortModel) {
        let id = program.programID
        likedPrograms.insert(id)
        unlikedPrograms.remove(id)
        programEventSubject.send(.added(univer, program))
        FavoritesBatcher.shared.addProgramChange(
            programID: id,
            isFavorite: true
        )
    }
    
    func removeProgramFromFavorites(programID: Int) {
        likedPrograms.remove(programID)
        unlikedPrograms.insert(programID)
        programEventSubject.send(.removed(programID))
        FavoritesBatcher.shared.addProgramChange(
            programID: programID,
            isFavorite: false
        )
    }
    
    func isProgramFavorited(programID: Int, serverValue: Bool) -> Bool {
        if serverValue, unlikedPrograms.contains(programID) {
            return false
        }
        if !serverValue, likedPrograms.contains(programID) {
            return true
        }
        return serverValue
    }
}


// MARK: - Olympiads
extension FavoritesManager {
    func addOlympiadToFavorites(model: OlympiadModel) {
        let id = model.olympiadID
        likedOlympiads.insert(id)
        unlikedOlympiads.remove(id)
        olympiadEventSubject.send(.added(model))
        FavoritesBatcher.shared.addOlympiadChange(
            olympiadID: id,
            isFavorite: true
        )
    }
    
    func removeOlympiadFromFavorites(olympiadId: Int) {
        likedOlympiads.remove(olympiadId)
        unlikedOlympiads.insert(olympiadId)
        olympiadEventSubject.send(.removed(olympiadId))
        FavoritesBatcher.shared.addOlympiadChange(
            olympiadID: olympiadId,
            isFavorite: false
        )
    }
    
    func isOlympiadFavorite(olympiadId: Int, serverValue: Bool) -> Bool {
        if serverValue, unlikedOlympiads.contains(olympiadId) {
            return false
        }
        if !serverValue, likedOlympiads.contains(olympiadId) {
            return true
        }
        return serverValue
    }
}

extension FavoritesManager {
    private func setupBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                self?.likedUniversities.removeAll()
                self?.unlikedUniversities.removeAll()
                self?.likedPrograms.removeAll()
                self?.unlikedPrograms.removeAll()
                self?.likedOlympiads.removeAll()
                self?.unlikedOlympiads.removeAll()
            }
            .store(in: &cancellables)
    }
}
