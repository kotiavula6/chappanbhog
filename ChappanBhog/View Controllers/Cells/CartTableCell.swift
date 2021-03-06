//
//  CartTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
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
    
    @IBOutlet weak var layoutConstraintWeightWidth: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintPriceLading: NSLayoutConstraint!
    
    var quantityIncBlock: SimpleBlock?
    var quantityDecBlock: SimpleBlock?
    var chooseOptioncBlock: SimpleBlock?
    var deleteBlock: SimpleBlock?
    var favouriteBlock: SimpleBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quantityIncreaseBTN.addTarget(self, action: #selector(qtyIncAction(_:)), for: UIControl.Event.touchUpInside)
        quantityDecreaseBTN.addTarget(self, action: #selector(qtyDecAction(_:)), for: UIControl.Event.touchUpInside)
        weightSelectBTN.addTarget(self, action: #selector(optionAction(_:)), for: UIControl.Event.touchUpInside)
        deleteBTN.addTarget(self, action: #selector(deleteAction(_:)), for: UIControl.Event.touchUpInside)
        favBTN.addTarget(self, action: #selector(favouriteAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
    
    @objc func deleteAction(_ sender: UIButton) {
        if let block = deleteBlock {
            block()
        }
    }
    
    @objc func favouriteAction(_ sender: UIButton) {
        if let block = favouriteBlock {
            block()
        }
    }
}
