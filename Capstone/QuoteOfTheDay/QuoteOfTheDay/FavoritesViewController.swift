//
//  FavoritesViewController.swift
//  QuoteOfTheDay
//
//  Created by Alexon Abreu on 4/19/25.
//

import UIKit

class FavoritesViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private var favorites: [ZenQuote] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    favorites = FavoritesManager.shared.getFavorites()
    tableView.reloadData()
  }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
    let quote = favorites[indexPath.row]
    cell.textLabel?.text = quote.q
    cell.detailTextLabel?.text = "- \(quote.a)"
    return cell
  }
    
// Swipe to delete feature
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
    // removing it from persistence
    let quoteToRemove = favorites[indexPath.row]
    FavoritesManager.shared.removeFavorite(quoteToRemove)

    // updating the local array
    favorites.remove(at: indexPath.row)

    // cool animation for deleting quotes
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}
}
