//
//  TopPicsTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import STRatingControl

class TopPicsTableCell: UITableViewCell {

    var increase:(()->())?
    var decrease:(()->())?
    var weigtAction:(()->())?
    
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var addTocartButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var totalReviewsLBL: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var increaseBTN: UIButton!
    @IBOutlet weak var decreaseBTN: UIButton!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet weak var starRating: STRatingControl!
    
    var quantity:Int = 1
    
    var cartBlock: SimpleBlock?
     
     override func awakeFromNib() {
         super.awakeFromNib()
         addTocartButton.addTarget(self, action: #selector(cartAction(_:)), for: UIControl.Event.touchUpInside)
     }
     
     @objc func cartAction(_ sender: UIButton) {
         if let block = cartBlock {
             block()
         }
     }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func buttonIncreaseClicked(_ sender: UIButton) {
        
        if let actio = increase {
            actio()
        }

    }
    @IBAction func buttonDecreaseClicked(_ sender: UIButton) {
        if let actio = decrease {
                actio()
            }
    }
    
    @IBAction func weightButtonClicked(_ sender: UIButton) {
        
        if let actio = weigtAction {
                      actio()
                  }
    }
    
    
}
