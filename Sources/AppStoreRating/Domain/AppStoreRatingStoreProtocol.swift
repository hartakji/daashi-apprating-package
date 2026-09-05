//
//  AppStoreRatingStoreProtocol.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

protocol AppStoreRatingStoreProtocol {
    func getAppRating(appId: String) async throws -> AppStoreRating
}
