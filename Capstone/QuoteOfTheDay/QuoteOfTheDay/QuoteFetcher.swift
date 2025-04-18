//
//  QuoteFetcher.swift
//  QuoteOfTheDay
//
//  Created by Alexon Abreu on 4/17/25.
//

import Foundation

struct ZenQuote: Decodable {
   let q: String
   let a: String
}


class QuoteFetcher {
   static let shared = QuoteFetcher()

   private init() {}


   func fetchDailyQuote(completion: @escaping (ZenQuote?, Error?) -> Void) {
       guard let url = URL(string: "https://zenquotes.io/api/random") else {
           completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
           return
       }


       URLSession.shared.dataTask(with: url) { data, response, error in
           if let error = error {
               completion(nil, error)
               return
           }


           guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
               completion(nil, NSError(domain: "Invalid Response", code: 0, userInfo: nil))
               return
           }


           guard let data = data else {
               completion(nil, NSError(domain: "No Data", code: 0, userInfo: nil))
               return
           }


           do {
               let decoder = JSONDecoder()
               // API returns an array, so we decode the array
               let zenQuotes = try decoder.decode([ZenQuote].self, from: data)
               // then we take the first quote from the array
               if let firstQuote = zenQuotes.first {
                   completion(firstQuote, nil)
               } else {
                   completion(nil, NSError(domain: "No quote in response", code: 0, userInfo: nil))
               }
           } catch {
               completion(nil, error)
           }
       }.resume()
   }
}