//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []
    let refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshController
        tableView.dataSource = self
        fetchPosts()
    }

        @objc func refreshData() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
       }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let post = posts[indexPath.row]
            cell.labelDescriptionOutlet.text = post.summary
            
            // getting the first photo in the post's photos array.
            if let photo = post.photos.first {
                let imageUrl = photo.originalSize.url
                print("Loading image from URL: \(imageUrl)")
                Nuke.loadImage(with: imageUrl, into: cell.imageViewOutlet)
            } else {
                cell.imageViewOutlet.image = nil
            }
            
            return cell
        }


    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    let posts = blog.response.posts
                    self?.posts = posts

                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    // we need this to load the content, otherwise we'll have a blank screen.
                    self?.tableView.reloadData()
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
