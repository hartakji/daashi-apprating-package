//
//  PlayStoreCounterConfigView.swift
//  AppRating
//
//  Created by Jean DAHER on 03/09/2026.
//

import SwiftUI

struct PlayStoreCounterConfigView: View {
    
    @State private var config: PlayStoreCounterConfig
    public var onSave: ((PlayStoreCounterConfig) -> Void)
    
    init(
        previousConfig: PlayStoreCounterConfig? = nil,
        onSave: (@escaping (PlayStoreCounterConfig) -> Void)
    ) {
        self.onSave = onSave
        self.config = previousConfig ?? PlayStoreCounterConfig(
            appId: "",
            refreshInterval: 15
        )
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("General")) {
                    TextField("App Id", text: $config.appId)
                }
                Section(header: Text("Refresh frequency")) {
                    Slider(value: $config.refreshInterval, in: 15...180, step: 15)
                    HStack {
                        Spacer()
                        Text("Refresh every \(String(format: "%1.0f", config.refreshInterval)) min")
                    }
                }
            }
            .navigationBarItems(
                trailing: HStack {
                    Button(
                        action: {
                            onSave(
                                config
                            )
                        },
                        label: {
                            Text(
                                "Sauvegarder"
                            )
                })
            })
        }
    }
}

#Preview {
    PlayStoreCounterConfigView(onSave: { config in
        print("config: \(config)")
    })
}
