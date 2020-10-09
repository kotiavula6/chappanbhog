//
//  LoadMoreCell.swift
//
//  Created by Vakul Saini on 15/06/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

let LOAD_MORE_CELL_HEIGHT: CGFloat = 44.0

class LoadMoreCell: UITableViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activity.color = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startAnimating() {
        self.activity.startAnimating()
        self.activity.isHidden = false
    }
    
    func stopAnimating() {
        self.activity.stopAnimating()
        self.activity.isHidden = true
    }
}
