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
}
