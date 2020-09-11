//
//  TopPicsTableCell.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class TopPicsTableCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
    }
    
}
