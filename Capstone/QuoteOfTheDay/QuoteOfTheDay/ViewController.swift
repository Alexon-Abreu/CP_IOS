//
//  ViewController.swift
//  QuoteOfTheDay
//
//  Created by Alexon Abreu on 4/17/25.
//

import UIKit


class ViewController: UIViewController {
  
  
   @IBOutlet weak var dailyQuote: UILabel!
   @IBOutlet weak var dailyQuoteAuthor: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton)
    {
        guard
                let text = dailyQuote.text,
                let author = dailyQuoteAuthor.text
            else { return }

            let quoteText = text.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            let authorText = author.trimmingCharacters(in: CharacterSet(charactersIn: "- "))

            let quote = ZenQuote(q: quoteText, a: authorText)

            if FavoritesManager.shared.isFavorite(quote) {
                FavoritesManager.shared.removeFavorite(quote)
            } else {
                FavoritesManager.shared.addFavorite(quote)
            }
            sender.isSelected.toggle()
    }
    
    
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       
        // loading today's quote (from cache or fetching a new one if needed)
        DailyQuoteManager.shared.loadQuote { [weak self] quote in
            DispatchQueue.main.async {
                guard let q = quote else {
                    self?.dailyQuote.text = "Failed to load quote."
                    self?.dailyQuoteAuthor.text = ""
                    return
                }
                // updating UI with the quote of the day
                self?.dailyQuote.text = "\"\(q.q)\""
                self?.dailyQuoteAuthor.text = "- \(q.a)"
                // restoring the favorite button state
                self?.favoriteButton.isSelected =
                    FavoritesManager.shared.isFavorite(q)
            }
        }

        // scheduling automatic quote refresh at next 12:00 PM EST
        DailyQuoteManager.shared.scheduleNextNoonUpdate { [weak self] in
            DailyQuoteManager.shared.loadQuote { newQuote in
                DispatchQueue.main.async {
                    guard let nq = newQuote else { return }
                    self?.dailyQuote.text = "\"\(nq.q)\""
                    self?.dailyQuoteAuthor.text = "- \(nq.a)"
                    self?.favoriteButton.isSelected =
                        FavoritesManager.shared.isFavorite(nq)
                }
            }
        }
   }
  
  
  
    func loadDailyQuote() {
        QuoteFetcher.shared.fetchDailyQuote { [weak self] zenQuote, error in
            DispatchQueue.main.async {
                // ... existing error handling ...

                if let quote = zenQuote {
                    self?.dailyQuote.text = "\"\(quote.q)\""
                    self?.dailyQuoteAuthor.text = "- \(quote.a)"

                    // Restore favorite state
                    self?.favoriteButton.isSelected =
                        FavoritesManager.shared.isFavorite(quote)
                }
            }
        }
    }
  
}
