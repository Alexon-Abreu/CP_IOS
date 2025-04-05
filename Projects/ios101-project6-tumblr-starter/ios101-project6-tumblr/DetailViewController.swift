//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Alexon Abreu on 4/5/25.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    // property to store the passed in Post object
    var post: Post!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // removing any potential HTML tags from strings
        textView.text = post.caption.trimHTMLTags()
        
        // loading the images using the Nuke library
        if post.photos.first != nil {
            guard let url = post.photos.first?.originalSize.url else { return}
            Nuke.loadImage(with: url, into: imageView)
        }
        
        navigationItem.largeTitleDisplayMode = .never

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
