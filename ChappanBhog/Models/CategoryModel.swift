//
//  CategoryModel.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 06/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class Categores: NSObject {
    
    var available_quantity:Int = 0
    var favorite:Int = 0
    var id:Int = 0
    var image:[String] = []
    var options:[Options] = []
    var price:Double = 0
    var ratings:Int = 1
    var reviews:Int = 0
    var title:String = ""
    var desc: String = ""
    
    // Only for local use - Start
    var selectedOptionId: Int = 0
    var quantity: Int = 1
    var isFavourite: Bool {
        return favorite == 1
    }
    // Only for local use - End
    
    
    convenience init(dict:[String:Any]) {
        self.init()
        setDict(dict)
    }
    
    func setDict(_ dict: [String: Any]) {
        if let value = dict["available_quantity"] as? String { available_quantity = Int(value) ?? 0 }
        if let value = dict["available_quantity"] as? Int { available_quantity = value }
        
        favorite = dict["favorite"] as? Int ?? 0
        id = dict["id"] as? Int ?? 0
        image = dict["image"] as? [String] ?? []
        desc = dict["description"] as? String ?? ""
        
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
                
        if let value = dict["price"] as? Double { price = value }
        else if let value = dict["price"] as? String { price = Double(value) ?? 0 }
        
        ratings = dict["ratings"] as? Int ?? 1
        reviews = dict["reviews"] as? Int ?? 0
        title = dict["title"] as? String ?? ""
        
        if let value = dict["selectedOptionId"] as? Int {
            selectedOptionId = value
        }
        if let value = dict["quantity"] as? Int {
            quantity = value
        }
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["available_quantity"] = available_quantity
        dict["favorite"] = favorite
        dict["id"] = id
        dict["image"] = image
        dict["price"] = price
        dict["ratings"] = ratings
        dict["reviews"] = reviews
        dict["title"] = title
        dict["description"] = desc
        
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
    
    func markFavourite(_ favourite: Bool, completion: @escaping (_ success: Bool) -> Void) {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        if userID == 0 {
            completion(false)
            return
        }
        
        let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_MARK_FAVOURITE
        let params: [String: Any] = ["user_id": "\(userID)", "product_id": "\(self.id)", "type": favourite ? "1" : "0"]
        AFWrapperClass.requestPOSTURL(url, params: params, success: { (dict) in
            let success = dict["success"] as? Bool ?? false
            if success { self.favorite = favourite ? 1 : 0}
            completion(true)
        }) { (error) in
            completion(false)
        }
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
