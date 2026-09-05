//
//  PlayStoreCounterEventHandler.swift
//  GithubWidget
//
//  Created by Jean DAHER on 03/09/2026.
//

import Foundation
import WidgetFoundation

@MainActor
class PlayStoreCounterEventHandler {
    
    var viewModel: PlayStoreCounterViewModel
    var interactor: PlayStoreRatingInteractorProtocol
    var config: PlayStoreCounterConfig
        
    required init(
        config: PlayStoreCounterConfig,
        viewModel: PlayStoreCounterViewModel,
        interactor: PlayStoreRatingInteractorProtocol
    ) {
        self.config = config
        self.viewModel = viewModel
        self.interactor = interactor
    }
    
    @MainActor
    func setViewModel(_ rating: PlayStoreRating) {
        self.viewModel.appRating = String(format: "%.1f", rating.rating)
        self.viewModel.reviewCount = Self.formattedReviewCount(rating.reviewCount)
    }
    
    static func formattedReviewCount(_ reviewCount: Int) -> String {
        if reviewCount < 1000 {
            return "\(reviewCount) reviews"
        }
        return String(format: "%.1fk reviews", Double(reviewCount) / 1000)
    }
    
    @MainActor
    func performAsyncTask() async {
        Task { [weak self] in
            guard let self else { return }
            do {
                let rating = try await interactor.getAppRating(appId: config.appId)
                setViewModel(rating)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func startFifteenMinuteLoop() {
        Task {
            await performAsyncTask()
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60*Double(config.refreshInterval)))
                guard !Task.isCancelled else { break }
                await performAsyncTask()
            }
        }
    }
}

extension PlayStoreCounterEventHandler: PlayStoreCounterViewDelegate {
    
    func didRequestRefresh() {
        // TODO: or not
    }
}

extension PlayStoreCounterEventHandler: WidgetEventHandlerProtocol {
    
    func onLoad() {
        startFifteenMinuteLoop()
    }
    
    @MainActor
    func onUnload() {
        
    }
}
