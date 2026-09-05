//
//  PlayStoreRatingInteractorProtocol.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

protocol PlayStoreRatingInteractorProtocol {
    func getAppRating(appId: String) async throws -> PlayStoreRating
}
