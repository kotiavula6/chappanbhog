//
//  CountryCodeCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 14/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    
    @IBOutlet weak var countryImageView: UIImageView!

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
