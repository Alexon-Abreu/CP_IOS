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
  
  
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       loadDailyQuote()
   }
  
  
  
   func loadDailyQuote() {
       QuoteFetcher.shared.fetchDailyQuote { [weak self] zenQuote, error in
           DispatchQueue.main.async {
               if let error = error {
                   print("Error fetching quote: \(error)")
                   self?.dailyQuote.text = "Failed to load quote."
                   self?.dailyQuoteAuthor.text = "" // clearing the previous author
                   return
               }


               if let quote = zenQuote {
                   self?.dailyQuote.text = "\"\(quote.q)\""
                   self?.dailyQuoteAuthor.text = "- \(quote.a)"
               }
           }
       }
   }
  
}