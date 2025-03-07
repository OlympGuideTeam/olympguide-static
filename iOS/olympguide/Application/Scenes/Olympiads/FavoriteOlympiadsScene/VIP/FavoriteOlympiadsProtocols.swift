//
//  FavoriteOlympiadsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 07.03.2025.
//

protocol FavoriteOlympiadsBusinessLogic {
    func handleBatchError(olympiadID: Int)
    func handleBatchSuccess(olympiadID: Int, isFavorite: Bool)
    func dislikeOlympiad(at index: Int)
    func likeOlympiad(_ olympiad: OlympiadModel, at insertIndex: Int)
}
