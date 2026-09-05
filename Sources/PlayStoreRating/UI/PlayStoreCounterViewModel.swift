//
//  PlayStoreCounterViewModel.swift
//  GithubWidget
//
//  Created by Jean DAHER on 03/09/2026.
//

import Combine

@MainActor
public class PlayStoreCounterViewModel: ObservableObject {
    
    @Published public var appRating: String
    @Published public var reviewCount: String
    
    init(
        appRating: String,
        reviewCount: String
    ) {
        self.appRating = appRating
        self.reviewCount = reviewCount
    }
}
