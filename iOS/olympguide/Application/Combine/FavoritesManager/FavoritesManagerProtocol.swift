//
//  FavoritesManagerProtocol.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import Combine

protocol FavoritesManagerProtocol {
    func addUniversityToFavorites(model: UniversityModel)
    func removeUniversityFromFavorites(universityID: Int)
    func handleBatchError(for id: Int, subject: FavoritesManager.Subject)
    func handleBatchSuccess(for id: Int, isFavorite: Bool, subject: FavoritesManager.Subject)
    func isUniversityFavorited(universityID: Int, serverValue: Bool) -> Bool

    func addProgramToFavorites(_ univer: UniversityModel, _ program: ProgramShortModel)
    func removeProgramFromFavorites(programID: Int)
    func isProgramFavorited(programID: Int, serverValue: Bool) -> Bool

    func addOlympiadToFavorites(model: OlympiadModel)
    func removeOlympiadFromFavorites(olympiadId: Int)
    func isOlympiadFavorite(olympiadId: Int, serverValue: Bool) -> Bool

    var universityEventSubject: PassthroughSubject<FavoritesManager.UniversityFavoriteEvent, Never> { get }
    var programEventSubject: PassthroughSubject<FavoritesManager.ProgramFavoriteEvent, Never> { get }
    var olympiadEventSubject: PassthroughSubject<FavoritesManager.OlympiadFavoriteEvent, Never> { get }
}
