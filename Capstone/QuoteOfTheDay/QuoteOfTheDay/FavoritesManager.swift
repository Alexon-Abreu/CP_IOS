//
//  FavoritesManager.swift
//  QuoteOfTheDay
//
//  Created by Alexon Abreu on 4/19/25.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favorites"

    private init() {}

    /// Returns the array of saved favorites, or empty if none.
    func getFavorites() -> [ZenQuote] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let quotes = try? JSONDecoder().decode([ZenQuote].self, from: data)
        else { return [] }
        return quotes
    }

    /// Returns true if the quote is currently favorited.
    func isFavorite(_ quote: ZenQuote) -> Bool {
        getFavorites().contains { $0.q == quote.q && $0.a == quote.a }
    }

    /// Adds a quote to favorites (if not already present).
    func addFavorite(_ quote: ZenQuote) {
        var current = getFavorites()
        guard !isFavorite(quote) else { return }
        current.append(quote)
        save(current)
    }

    /// Removes a quote from favorites.
    func removeFavorite(_ quote: ZenQuote) {
        let filtered = getFavorites().filter { !($0.q == quote.q && $0.a == quote.a) }
        save(filtered)
    }

    /// Internal helper to encode & save the array.
    private func save(_ quotes: [ZenQuote]) {
        if let data = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
