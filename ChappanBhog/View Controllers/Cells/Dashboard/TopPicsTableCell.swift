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
    
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var weightLBL: UILabel!
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
    @IBOutlet weak var layoutConstraintWeightWidth: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintWeightTrailing: NSLayoutConstraint!
    
     var cartBlock: SimpleBlock?
     var quantityIncBlock: SimpleBlock?
     var quantityDecBlock: SimpleBlock?
     var chooseOptioncBlock: SimpleBlock?
     
     override func awakeFromNib() {
         super.awakeFromNib()
         addTocartButton.addTarget(self, action: #selector(cartAction(_:)), for: UIControl.Event.touchUpInside)
         increaseBTN.addTarget(self, action: #selector(qtyIncAction(_:)), for: UIControl.Event.touchUpInside)
         decreaseBTN.addTarget(self, action: #selector(qtyDecAction(_:)), for: UIControl.Event.touchUpInside)
         weightBTN.addTarget(self, action: #selector(optionAction(_:)), for: UIControl.Event.touchUpInside)
     }
     
     @objc func cartAction(_ sender: UIButton) {
         if let block = cartBlock {
             block()
         }
     }
     
     @objc func qtyIncAction(_ sender: UIButton) {
         if let block = quantityIncBlock {
             block()
         }
     }
     
     @objc func qtyDecAction(_ sender: UIButton) {
         if let block = quantityDecBlock {
             block()
         }
     }
     
     @objc func optionAction(_ sender: UIButton) {
         if let block = chooseOptioncBlock {
             block()
         }
     }
}
