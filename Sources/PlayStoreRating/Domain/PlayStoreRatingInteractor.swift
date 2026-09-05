//
//  PlayStoreRatingInteractor.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

struct PlayStoreRatingInteractor {
    
    private let store: PlayStoreRatingStoreProtocol
    
    init(
        store: PlayStoreRatingStoreProtocol
    ) {
        self.store = store
    }
}

extension PlayStoreRatingInteractor: PlayStoreRatingInteractorProtocol {
    
    public func getAppRating(appId: String) async throws -> PlayStoreRating {
        try await store.getAppRating(appId: appId)
    }
}
