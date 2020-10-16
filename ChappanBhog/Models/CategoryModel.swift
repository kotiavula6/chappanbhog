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
    var options:[Options] = []
    var price:Double?
    var ratings:Int?
    var reviews:Int?
    var title:String?
    
    
    // Only for local use - Start
    var selectedOptionId: Int = 0
    var quantity: Int = 1
    // Only for local use - End
    
    
    init(dict:[String:Any]) {
        super.init()
        available_quantity = dict["available_quantity"] as? String
        favorite = dict["favorite"] as? Int
        id = dict["id"] as? Int
        image = dict["image"] as? [String]
        
        options.removeAll()
        options = []
        if let values = dict["options"] as? [[String: Any]] {
            for value in values {
                let option = Options(dict: value)
                options.append(option)
                
                if selectedOptionId == 0 {
                    selectedOptionId = option.id
                }
            }
        }
                
        price = dict["price"] as? Double
        ratings = dict["ratings"] as? Int
        reviews = dict["reviews"] as? Int
        title = dict["title"] as? String
        
        if let value = dict["selectedOptionId"] as? Int {
            selectedOptionId = value
        }
        if let value = dict["quantity"] as? Int {
            quantity = value
        }
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let value = self.available_quantity {
            dict["available_quantity"] = value
        }
        if let value = self.favorite {
            dict["favorite"] = value
        }
        if let value = self.id {
            dict["id"] = value
        }
        if let value = self.image {
            dict["image"] = value
        }
        if let value = self.price {
            dict["price"] = value
        }
        if let value = self.ratings {
            dict["ratings"] = value
        }
        if let value = self.reviews {
            dict["reviews"] = value
        }
        if let value = self.title {
            dict["title"] = value
        }
        
        var i: [[String: Any]] = []
        for option in options {
            i.append(option.getDict())
        }
        dict["options"] = i
        
        dict["selectedOptionId"] = selectedOptionId
        dict["quantity"] = quantity
        
        return dict
    }
    
    func selectedOption() -> Options {
        let result = self.options.filter({$0.id == selectedOptionId})
        return result.first ?? Options()
    }
}

class Options: NSObject {
    var id: Int = 0
    var name: String = ""
    var price: Double = 0
    
    convenience init(dict:[String:Any]) {
        self.init()
        id = dict["id"] as? Int ?? 0
        name = dict["name"] as? String ?? ""
        
        if let value = dict["price"] as? Double { price = value }
        else if let value = dict["price"] as? String { price = Double(value) ?? 0 }
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = self.id
        dict["name"] = self.name
        dict["price"] = self.price
        return dict
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
