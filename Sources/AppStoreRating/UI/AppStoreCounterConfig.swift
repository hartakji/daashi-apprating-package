//
//  AppStoreCounterConfig.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

import WidgetFoundation

public struct AppStoreCounterConfig: WidgetConfigPayload {
    public static let componentIdentifier = "daashi.appRating.appStore-counter"

    var appId: String
    var refreshInterval: Float
}
