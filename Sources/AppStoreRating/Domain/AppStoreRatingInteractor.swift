//
//  AppStoreRatingInteractor.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

struct AppStoreRatingInteractor {
    
    private let store: AppStoreRatingStoreProtocol
    
    init(
        store: AppStoreRatingStoreProtocol
    ) {
        self.store = store
    }
}

extension AppStoreRatingInteractor: AppStoreRatingInteractorProtocol {
    func getAppRating(appId: String) async throws -> AppStoreRating {
        try await store.getAppRating(appId: appId)
    }
    
    
}
