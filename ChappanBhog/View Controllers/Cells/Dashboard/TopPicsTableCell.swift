//
//  TopPicsTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class TopPicsTableCell: UITableViewCell {

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
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var weightBTN: UIButton!
    
    var quantity:Int = 1
    
    
    override func awakeFromNib() {
//        setShadowRadius(view: shadowView)
//        DispatchQueue.main.async {
//            setShadow(view: self.shadowView, cornerRadius: 20, shadowRadius: 5, shadowOpacity: 2)
 //       }
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        
    }
    
}
