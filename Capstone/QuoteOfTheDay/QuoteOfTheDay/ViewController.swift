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
       loadDailyQuote()
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
