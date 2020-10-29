//
//  TopPicsTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
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
    
    @IBOutlet weak var layoutConstraintShelfLifeTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintShelfLifeBottom: NSLayoutConstraint!
    
    @IBOutlet weak var layoutConstraintAvailabilityTextTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintAvailabilityTextBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lblShelfLife: UILabel!
    @IBOutlet weak var lblAvailabilityText: UILabel!
    
    var cartBlock: SimpleBlock?
    var quantityIncBlock: SimpleBlock?
    var quantityDecBlock: SimpleBlock?
    var chooseOptioncBlock: SimpleBlock?
    var favouriteBlock: SimpleBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTocartButton.addTarget(self, action: #selector(cartAction(_:)), for: UIControl.Event.touchUpInside)
        increaseBTN.addTarget(self, action: #selector(qtyIncAction(_:)), for: UIControl.Event.touchUpInside)
        decreaseBTN.addTarget(self, action: #selector(qtyDecAction(_:)), for: UIControl.Event.touchUpInside)
        weightBTN.addTarget(self, action: #selector(optionAction(_:)), for: UIControl.Event.touchUpInside)
        favButton.addTarget(self, action: #selector(favouriteAction), for: UIControl.Event.touchUpInside)
        
        lblShelfLife.superview?.layer.cornerRadius = 10
        lblShelfLife.superview?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        lblAvailabilityText.superview?.layer.cornerRadius = 10
        lblAvailabilityText.superview?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
    
    @objc func favouriteAction(_ sender: UIButton) {
        if let block = favouriteBlock {
            block()
        }
    }

}
