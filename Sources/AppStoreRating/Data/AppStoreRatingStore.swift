//
//  AppStoreRatingStore.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

import Foundation
import RegexBuilder
import SwiftSoup

struct AppStoreRatingStore {
    
    public enum Error: Swift.Error {
        case invalidUrl
        case invalidResponse
    }
}

extension AppStoreRatingStore: AppStoreRatingStoreProtocol {
    
    public func getAppRating(appId: String) async throws -> AppStoreRating {
        let urlString = "https://apps.apple.com/fr/app/-/\(appId)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlString, let url = URL(string: urlString) else {
            throw Error.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let response = String(data: data, encoding: .utf8) else { throw Error.invalidResponse }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = ","
        numberFormatter.groupingSeparator = "\u{00A0}"

        let doc: Document = try SwiftSoup.parse(response)

        // Rating and review count are rendered with stable `data-testid` attributes,
        // rather than the CSS classes (which are Svelte-hashed and change across builds).
        guard let ratingElement = try doc.select("[data-testid=amp-rating__average-rating]").first() else {
            throw Error.invalidResponse
        }
        let appRatingString = ratingElement.ownText()

        guard let countElement = try doc.select("[data-testid=amp-rating__rating-count-text]").first() else {
            throw Error.invalidResponse
        }
        // Google-style non-breaking spaces (U+00A0) separate the number, the "k" suffix and
        // the unit, e.g. "13\u{00A0}k\u{00A0}notes" or "96\u{00A0}notes".
        var reviewCountString = countElement.ownText()
            .replacingOccurrences(of: "\u{00A0}notes", with: "")
            .replacingOccurrences(of: " notes", with: "")

        let reviewCount: Int
        if reviewCountString.contains("\u{00A0}k") || reviewCountString.contains(" k") {
            reviewCountString = reviewCountString
                .replacingOccurrences(of: "\u{00A0}k", with: "")
                .replacingOccurrences(of: " k", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let thousands = numberFormatter.number(from: reviewCountString)?.doubleValue ?? 0
            reviewCount = Int((thousands * 1000).rounded())
        } else {
            guard let count = numberFormatter.number(from: reviewCountString)?.intValue else {
                throw Error.invalidResponse
            }
            reviewCount = count
        }

        guard let rating = numberFormatter.number(from: appRatingString) else {
            throw Error.invalidResponse
        }

        return AppStoreRating(rating: rating.floatValue, reviewCount: reviewCount)
    }
}
