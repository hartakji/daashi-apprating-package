//
//  AppRatingWidgetPackDescriptor.swift
//  AppRatingWidget
//
//  Created by Jean DAHER on 28/08/2026.
//

import WidgetFoundation
import SwiftUI

public struct AppRatingWidgetPackDescriptor: WidgetPackDescriptor {
    
    public static var packInfo: WidgetPackInfo {
        WidgetPackInfo(
            name: "Github",
            description: "Widgets to interface with Github through its API",
            image: Image("ic_widgetPack_appRating", bundle: .module)
        )
    }
    
    public static var widgets: [WidgetFoundation.Widget] {
        [
            Widget(
                identifier: AppStoreCounterConfig.componentIdentifier,
                name: "App Store app rating",
                description: "Your app's rating on the App Store",
                image: Image("ic_appstore", bundle: .module),
                availableFormFactor: [.square],
                availableSize: [.small]
            ),
            Widget(
                identifier: PlayStoreCounterConfig.componentIdentifier,
                name: "Play Store app rating",
                description: "Your app's rating on the Play Store",
                image: Image("ic_playstore", bundle: .module),
                availableFormFactor: [.square],
                availableSize: [.small]
            ),
        ]
    }

    public static func configType(
        for identifier: String
    ) -> WidgetFoundation.WidgetConfigPayload.Type {
        switch identifier {
        case AppStoreCounterConfig.componentIdentifier:
            return AppStoreCounterConfig.self
        case PlayStoreCounterConfig.componentIdentifier:
            return PlayStoreCounterConfig.self
        default:
            break
        }
        fatalError("Unable to find config for \(identifier)")
    }
    
    @MainActor
    public static func makeView<T>(
        for identifier: String,
        config: T
    ) -> (AnyView, any WidgetEventHandlerProtocol) where T : WidgetConfigPayload {
        switch identifier {
            
        case AppStoreCounterConfig.componentIdentifier:
            if let config = config as? AppStoreCounterConfig {
                
                let viewModel = AppStoreCounterViewModel(
                    appRating: "N/A",
                    reviewCount: "N/A"
                )
                let eventHandler = AppStoreCounterEventHandler(
                    config: config,
                    viewModel: viewModel,
                    interactor: AppStoreRatingInteractor(
                        store: AppStoreRatingStore()
                    )
                )

                let view = AppStoreCounterView(viewModel: viewModel, delegate: eventHandler)
                
                return (view: AnyView(view), eventHandler: eventHandler)
            }
            
        case PlayStoreCounterConfig.componentIdentifier:
            if let config = config as? PlayStoreCounterConfig {
                
                let viewModel = PlayStoreCounterViewModel(
                    appRating: "N/A",
                    reviewCount: "N/A"
                )
                let eventHandler = PlayStoreCounterEventHandler(
                    config: config,
                    viewModel: viewModel,
                    interactor: PlayStoreRatingInteractor(
                        store: PlayStoreRatingStore()
                    )
                )

                let view = PlayStoreCounterView(viewModel: viewModel, delegate: eventHandler)
                
                return (view: AnyView(view), eventHandler: eventHandler)
            }
        default:
            break
        }
        
        fatalError("Unable to make view for identifier: \(identifier)")
    }
    
    @MainActor
    public static func makeConfigurator(
        for identifier: String,
        config: (any WidgetConfigPayload)?,
        onSave: @escaping (any WidgetConfigPayload) -> Void
    ) -> AnyView {
        switch identifier {
            
        case AppStoreCounterConfig.componentIdentifier:
            if let config = config as? AppStoreCounterConfig? {
                let view = AppStoreCounterConfigView(
                    previousConfig: config,
                    onSave: { newConfig in
                        onSave(newConfig)
                    }
                )
                return AnyView(view)
            }
        case PlayStoreCounterConfig.componentIdentifier:
            if let config = config as? PlayStoreCounterConfig? {
                let view = PlayStoreCounterConfigView(
                    previousConfig: config,
                    onSave: { newConfig in
                        onSave(newConfig)
                    }
                )
                return AnyView(view)
            }
        default:
            break
        }
        
        fatalError("Unable to make configurator view for identifier: \(identifier)")
    }
}
