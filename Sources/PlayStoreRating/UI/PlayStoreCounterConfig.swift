//
//  PlayStoreCounterConfig.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

import WidgetFoundation

public struct PlayStoreCounterConfig: WidgetConfigPayload {
    public static let componentIdentifier = "daashi.appRating.playStore-counter"

    var appId: String
    var refreshInterval: Float
}
