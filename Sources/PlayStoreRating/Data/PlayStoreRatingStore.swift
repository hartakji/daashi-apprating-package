//
//  PlayStoreRatingStore.swift
//  daashi-appRating-widget
//
//  Created by Jean DAHER on 05/09/2026.
//

import Foundation
import RegexBuilder
import SwiftSoup

struct PlayStoreRatingStore {
    
    enum Error: Swift.Error {
        case invalidUrl
        case invalidResponse
    }
}

extension PlayStoreRatingStore: PlayStoreRatingStoreProtocol {
    
    func getAppRating(appId: String) async throws -> PlayStoreRating {
        let urlString = "https://play.google.com/store/apps/details?id=\(appId)"
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
        let reviewCount: Int?
        
        let doc: Document = try SwiftSoup.parse(response)
        let divReview: Element = try doc.select("div.g1rdde").first()!
        // Google separates the number from its unit with a non-breaking space (U+00A0),
        // e.g. "96\u{00A0}avis" or "12\u{00A0}k\u{00A0}avis".
        var reviewCountString = divReview.ownText()
            .replacingOccurrences(of: "\u{00A0}avis", with: "")
            .replacingOccurrences(of: " avis", with: "")
        if reviewCountString.contains("\u{00A0}k") || reviewCountString.contains(" k") {
            reviewCountString = reviewCountString
                .replacingOccurrences(of: "\u{00A0}k", with: "")
                .replacingOccurrences(of: " k", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let thousands = numberFormatter.number(from: reviewCountString)?.doubleValue ?? 0
            reviewCount = Int((thousands * 1000).rounded())
        } else {
            reviewCount = numberFormatter.number(from: reviewCountString)?.intValue
        }
        
        guard let divRating: Element = try doc.select("div.TT9eCd").first() else { throw Error.invalidResponse }
        // The rating value isn't a direct text node of the div (ownText() would be empty);
        // it lives in a nested <span aria-hidden="true">4,9</span>.
        guard let ratingSpan = try divRating.select("span[aria-hidden=true]").first() else { throw Error.invalidResponse }
        let ratingString = ratingSpan.ownText()
       
        guard let rating = numberFormatter.number(from: ratingString),
              let reviewCount
        else {
            throw Error.invalidResponse
        }
        
        return PlayStoreRating(rating: rating.floatValue, reviewCount: reviewCount)
    }
}
