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

class ShopCategory: NSObject {
    var id: String = ""
    var name: String = ""
    var slug: String = ""
    var parent: String = ""
    var desc: String = ""
    var display: String = ""
    var image: String = ""
    var count: String = ""
    
    init(dict: [String: Any]) {
        // Id will be either number or string as it is in numeric form
        if let value = dict["id"] as? Int { id = "\(value)" }
        else if let value = dict["id"] as? String { id = value }
        
        // Name
        if let value = dict["name"] as? String { name = value }
        
        // Slug
        if let value = dict["slug"] as? String { slug = value }
        
        // Can be number or string
        if let value = dict["parent"] as? Int { parent = "\(value)" }
        else if let value = dict["parent"] as? String { parent = value }
        
        // Description
        if let value = dict["description"] as? String { desc = value }
        
        // Display
        if let value = dict["display"] as? String { display = value }
        
        // Image
        if let value = dict["image"] as? String { image = value }
        
        // Can be number or string
        if let value = dict["count"] as? Int { count = "\(value)" }
        else if let value = dict["count"] as? String { count = value }
    }
}
