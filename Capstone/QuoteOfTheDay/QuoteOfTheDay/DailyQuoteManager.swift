//
//  DailyQuoteManager.swift
//  QuoteOfTheDay
//
//  Created by Alexon Abreu on 4/21/25.
//

import Foundation

class DailyQuoteManager {
    static let shared = DailyQuoteManager()
    private let quoteKey = "dailyQuote"
    private let dateKey  = "lastFetchDate"
    private let estTimeZone = TimeZone(identifier: "America/New_York")!
    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "America/New_York")!
        return cal
    }()
    
    private init() {}
    
    /// returning the saved quote for today, if it exists and is still valid.
    func getSavedQuote() -> ZenQuote? {
        guard
            let data = UserDefaults.standard.data(forKey: quoteKey),
            let quote = try? JSONDecoder().decode(ZenQuote.self, from: data)
        else { return nil }
        return quote
    }
    
    /// checking to see the last fetch date (in EST), if any.
    func getLastFetchDate() -> Date? {
        UserDefaults.standard.object(forKey: dateKey) as? Date
    }
    
    /// saving a new daily quote and the current timestamp.
    private func save(quote: ZenQuote, at date: Date) {
        if let data = try? JSONEncoder().encode(quote) {
            UserDefaults.standard.set(data, forKey: quoteKey)
            UserDefaults.standard.set(date, forKey: dateKey)
        }
    }
    
    // this function checks to see if we need to fetch a fresh quote.
    // this is only the case when it's noon EST or later, and we haven't fetched for a quote today at noon yet.
    private func shouldFetchNewQuote() -> Bool {
        let now = Date()
        // calculating today’s noon EST
        guard let todayNoon = calendar.nextDate(
                after: now.addingTimeInterval(-86400),  // starting from yesterday to include today's noon
                matching: DateComponents(hour: 12, minute: 0, second: 0),
                matchingPolicy: .nextTime
        ) else { return true }
        
        // if now >= todayNoon AND lastFetch < todayNoon, we need to fetch a new quote
        if now >= todayNoon {
            if let last = getLastFetchDate(), last >= todayNoon {
                return false
            }
            return true      // time for a new daily quote
        }
        return false  // before noon, keep yesterday’s quote
    }
    
    func loadQuote(completion: @escaping (ZenQuote?) -> Void) {
        if let saved = getSavedQuote(), !shouldFetchNewQuote() {
            completion(saved)  // return the stored quote
        } else {
            QuoteFetcher.shared.fetchDailyQuote { quote, error in
                guard let q = quote else {
                    completion(nil)  // handling errors on upstream
                    return
                }
                let now = Date()
                self.save(quote: q, at: now)
                completion(q)     // return new quote
            }
        }
    }
    
    // scheduling the next automatic fetch for a quote at the upcoming noon EST.
    func scheduleNextNoonUpdate(callback: @escaping () -> Void) {
            let now = Date()
            // finding the next 12:00 PM EST
            guard let nextNoon = calendar.nextDate(
                    after: now,
                    matching: DateComponents(hour: 12, minute: 0, second: 0),
                    matchingPolicy: .nextTime
            ) else { return }

            // creating a non‑repeating timer that fires at the nextNoon
            let timer = Timer(fire: nextNoon, interval: 0, repeats: false) { _ in
                callback()
                // rescheduling the timer for the following day at noon
                self.scheduleNextNoonUpdate(callback: callback)
            }

            // adding it to the main run‑loop so it actually fires
            RunLoop.main.add(timer, forMode: .common)
        }
}
