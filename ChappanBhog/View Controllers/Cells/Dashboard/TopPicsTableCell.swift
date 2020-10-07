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
    
    
    override func awakeFromNib() {
//        setShadowRadius(view: shadowView)
//        DispatchQueue.main.async {
//            setShadow(view: self.shadowView, cornerRadius: 20, shadowRadius: 5, shadowOpacity: 2)
 //       }
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
}
