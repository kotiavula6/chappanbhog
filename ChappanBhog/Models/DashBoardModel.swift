//
//  DashBoardModel.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 29/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation


class BannersdashBoard:NSObject {
    var id:Int?
    var image:String?
    var title:String?
    var type:Int?

    init(dict: [String:Any]) {
    super.init()
        id = dict["id"] as? Int
        image = dict["image"] as? String
        title = dict["title"] as? String
        type = dict["type"] as? Int
    }
}

class TopPics: NSObject {
    
    var available_quantity:Int?
    var favorite:Int?
    var id:Int?
    var image:[String]?
    var options = [optionss]()
    var price:Int?
    var ratings:Int?
    var reviews:Int?
    var title:String?

    init(dict: [String:Any]) {
        super.init()
        
        available_quantity = dict["available_quantity"] as? Int
        favorite = dict["favorite"] as? Int
        id = dict["id"] as? Int
        image = dict["image"] as? [String]
        price = dict["price"] as? Int
        ratings = dict["ratings"] as? Int
        reviews = dict["reviews"] as? Int
        title = dict["title"] as? String
//        let optio = dict["options"] as? NSArray ?? NSArray()
//   
//  
//        for i in 0..<optio.count {
//            self.options.append(optionss(dict: optio.object(at: i) as! [String : Any]))
//        }
      
    
    }
}

class optionss:NSObject {
    
    var id:Int?
    var name:String?
    var price:Int?
    
    init(dict:[String:Any]) {
        super.init()
        
        id = dict["id"] as? Int
        name = dict["name"] as? String
        price = dict["options"] as? Int
        
    }
    
}

class categories: NSObject {
    
    var count:Int?
    var desc:String?
    var display:String?
    var id:Int?
    var image:String?
    var name:String? {
        didSet {
            /*if let _name = name {
                name = _name.parseHTML()
            }*/
        }
    }
    var parent:Int?
    var slug:String?
    
    init(dict: [String:Any]) {
        super.init()
        desc = dict["description"] as? String
        id = dict["id"] as? Int
        image = dict["image"] as? String
        name = dict["name"] as? String
        display = dict["display"] as? String
        parent = dict["parent"] as? Int
        slug = dict["slug"] as? String
        
        /*if let _name = name {
            name = _name.parseHTML()
        }*/
    }
}

