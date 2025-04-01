//
//  TableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Alexon Abreu on 3/31/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var labelDescriptionOutlet: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
