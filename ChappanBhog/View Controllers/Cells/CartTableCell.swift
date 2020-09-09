//
//  CartTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CartTableCell: UITableViewCell {

    @IBOutlet weak var PriceLBL: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var weightSelectBTN: UIButton!
    @IBOutlet weak var weightLBL: UILabel!
    @IBOutlet weak var favBTN: UIButton!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var quantityIncreaseBTN: UIButton!
    @IBOutlet weak var quantityDecreaseBTN: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setShadowRadius(view: shadowView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
