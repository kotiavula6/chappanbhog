//
//  OurMenuTableCell.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 12/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import SDWebImage

class OurMenuTableCell: UITableViewCell {
    
    @IBOutlet weak var iVIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var shapeLayer: CAShapeLayer?
    var shopCategory: ShopCategory? {
        didSet {
            refresh()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // setUpColor() // Uncomment for random color
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createCustomShape()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
        
    func setUpColor() {
        contentView.backgroundColor = UIColor.random
    }
    
    func createCustomShape() {
        guard let container = iVIcon.superview else { return }
        
        let p1 = CGPoint.zero
        let p2 = CGPoint(x: container.frame.maxX, y: 0)
        let p3 = CGPoint(x: container.frame.maxX - 20, y: container.frame.maxY)
        let p4 = CGPoint(x: 0, y: container.frame.maxY)
        
        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.close()
        
        if let layer = self.shapeLayer {
            layer.path = path.cgPath
        }
        else {
            shapeLayer = CAShapeLayer()
            shapeLayer?.path = path.cgPath
            container.layer.mask = shapeLayer
        }
    }
    
    func refresh() {
        clear()
        guard let category = self.shopCategory else { return }
        lblTitle.text = category.name
        // lblDesc.text =
        self.iVIcon.sd_imageIndicator = AppDelegate.shared.sd_indicator()
        self.iVIcon.sd_setImage(with: URL(string: category.image )) { (image, error, type, _url) in }
    }
    
    func clear() {
        lblTitle.text = ""
       // lblDesc.text = ""
        iVIcon.image = nil
    }
}
