//
//  CategoryModel.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 06/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class Categores: NSObject {
    
var available_quantity:String?
var favorite:Int?
var id:Int?
var image:[String]?
var options:[options]?
var price:Int?
var ratings:Int?
var reviews:Int?
var title:String?
    
    init(dict:[String:Any]) {
        super.init()
       available_quantity = dict["available_quantity"] as? String
        favorite = dict["favorite"] as? Int
        id = dict["id"] as? Int
        image = dict["image"] as? [String]
        options = dict["options"] as? [options]
        price = dict["options"] as? Int
        ratings = dict["ratings"] as? Int
        reviews = dict["reviews"] as? Int
        title = dict["title"] as? String
        
        
    }
    
}
class options:NSObject {
    
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

