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
    
    var increase:(()->())?
    var decrease:(()->())?
    var fav:(()->())?
    var delete:(()->())?
    var weigtAction:(()->())?
    var quantity:Int = 1


    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func increaseAction(_ sender: UIButton) {
  
        if let actio = increase {
            actio()
        }
    
    }
    @IBAction func decreaseAction(_ sender: UIButton) {
    if let actio = decrease {
               actio()
           }
    
    }
 
    @IBAction func weightAction(_ sender: UIButton) {
        if let actio = weigtAction {
            actio()
        }
    }
    
    @IBAction func favAction(_ sender: UIButton) {
        if let actio = fav {
                     actio()
                 }
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        if let actio = delete {
                     actio()
                 }
    }
}
