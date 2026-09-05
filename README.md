# AppRatingWidget

A Swift package that provides a [Daashi Widget Foundation](https://github.com/hartakji/daashi-widget-foundation) widget pack to fetch and display your app's rating from the **App Store** and **Play Store**. It crawls each store's public app page and extracts the current rating and review count — no API key required.

## Requirements

- iOS 16.0+
- Swift 5.7+
- A [`daashi-widget-foundation`](https://github.com/hartakji/daashi-widget-foundation) host application

## Installation

Add the package as a dependency via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/hartakji/daashi-appRating-package", from: "1.0.0")
]
```

## Widget Pack

The package registers itself with the Widget Foundation via `AppRatingWidgetPackDescriptor`, which declares the pack's metadata (name, description, icon) and the list of widgets it provides.

### App Store app rating

Displays your app's current rating and review count from the App Store.

- **Identifier**: `daashi.appRating.appStore-counter`
- **Available form factor**: square
- **Available size**: small

### Play Store app rating

Displays your app's current rating and review count from the Play Store.

- **Identifier**: `daashi.appRating.playStore-counter`
- **Available form factor**: square
- **Available size**: small

#### Configuration

Both widgets share the same configuration shape — an app identifier and a refresh interval:

```swift
public struct AppStoreCounterConfig: WidgetConfigPayload {
    var appId: String       // numeric App Store app ID
    var refreshInterval: Float
}

public struct PlayStoreCounterConfig: WidgetConfigPayload {
    var appId: String       // Play Store package name (e.g. "com.example.app")
    var refreshInterval: Float
}
```

#### How it works

Each widget fetches the public store page for the configured app and parses the HTML with [SwiftSoup](https://github.com/scinfu/SwiftSoup) to extract the rating and review count, refreshing automatically on the configured interval:

1. **Data** (`AppStoreRatingStore`, `PlayStoreRatingStore`) — downloads the store page HTML and parses the rating/review count from stable DOM anchors (`data-testid` attributes on the App Store, CSS classes on the Play Store).
2. **Domain** (`AppStoreRatingInteractor`, `PlayStoreRatingInteractor`) — exposes the parsed rating to the UI layer.
3. **UI** (`*CounterView`, `*CounterViewModel`, `*CounterEventHandler`) — renders the widget and periodically refreshes it via the event handler's refresh loop. Review counts are formatted as `"999 reviews"` below 1,000 and `"13.0k reviews"` above.

## Architecture

Each widget in this package follows a layered structure:

```
Sources/
├── AppStoreRating/
│   ├── Data/       # HTML fetching & parsing (Store)
│   ├── Domain/     # Business logic (Interactor, domain model, protocols)
│   └── UI/         # SwiftUI views, view models, config, and event handling
└── PlayStoreRating/
    ├── Data/
    ├── Domain/
    └── UI/
```

> **Note**: These widgets scrape public store pages rather than using an official API. Store page markup can change over time, which may require selector updates in the `Data` layer.

## License

See the repository for license details.
