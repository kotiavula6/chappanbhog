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
    var meta: CategoryMeta = CategoryMeta()
    var price:Double = 0
    var ratings:Int = 1
    var reviews:Int = 0
    var title:String = "" {
        didSet {
            //title = title.parseHTML()
        }
    }
    var desc: String = ""
    
    // Only for local use - Start
    var selectedOptionId: Int = 0
    var quantity: Int = 1
    var isFavourite: Bool {
        return favorite == 1
    }
    var totalPrice: Double {
        let option = self.selectedOption()
        if  option.id > 0 {
            let price = option.totalPrice * Double(self.quantity)
            return price
        }
        else {
            let metaPrice = meta.totalPrice
            if metaPrice > 0 {
                let price = metaPrice * Double(self.quantity)
                return price
            }
            
            let price = self.price * Double(self.quantity)
            return price
        }
    }
    
    var totalPriceWithoutQuantity: Double {
        let option = self.selectedOption()
        if  option.id > 0 {
            let price = option.totalPrice
            return price
        }
        else {
            let metaPrice = meta.totalPrice
            if metaPrice > 0 {
                let price = metaPrice
                return price
            }
            
            let price = self.price
            return price
        }
    }
    
    func fullTitleAttributedText(titleFont: UIFont) -> NSMutableAttributedString {
        let fullStr = "\(title) (\(meta.sub_title))" as NSString
        let attributedText = NSMutableAttributedString(string: fullStr as String)
        attributedText.addAttributes([NSAttributedString.Key.font: titleFont], range: fullStr.range(of: title)) // BrandonGrotesque-Bold 15.0
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "BrandonGrotesque-Regular", size: titleFont.pointSize - 3) ?? UIFont.systemFont(ofSize: titleFont.pointSize - 3)], range: fullStr.range(of: "(\(meta.sub_title))"))
        return attributedText
    }
    
    var canShow: Bool = true // If false don't show
    var canAddToCart: Bool = true // If false disable add to cart button
    var showAvailabilityText: Bool = false // If true show availablity text
    var isAvailable: Bool = true // if false product is not available now
    var useLucknowPrice: Bool = false { // If true we have to use lucknow location price
        didSet {
            for option in options { option.useLucknowPrice = self.useLucknowPrice }
            meta.useLucknowPrice = self.useLucknowPrice
        }
    }
    
    func reset() {
        canShow = true
        canAddToCart = true
        showAvailabilityText = false
        useLucknowPrice = true
    }
    
    func performAvailabilityCheck() {
        reset()
        
        let country = AppDelegate.shared.currentCountry.lowercased()
        let city = AppDelegate.shared.currentCity.lowercased()
        
        
        if country == "india" {
            if let ship_to_india = meta.ship_to_india, let ship_to_lucknow = meta.ship_to_lucknow, ((ship_to_india == "" || ship_to_india == "no") && (ship_to_lucknow == "" || ship_to_lucknow == "no")) {
                // don't show this product
                // echo "Don't show this product 1.";
                canShow = false
                return
            } else {
                if city == "lucknow" {
                    if let enable_for_lko = meta.enable_for_lko, (enable_for_lko == "" || enable_for_lko == "no") {
                        // echo "Don't show this product 2.";
                        canShow = false
                        return
                    } else {
                        //- show product
                        //- price = lko_price || regular_price
                        useLucknowPrice = true
                        if let ship_to_lucknow = meta.ship_to_lucknow, (ship_to_lucknow == "" || ship_to_lucknow == "no") {
                            //- hide add to cart
                            // echo "Hide add to cart 1.";
                            canAddToCart = false
                        } else {
                            if let setavailability = meta.setavailability, setavailability == "yes" {
                                // Show availabilitytext
                                let currentTime = Date()
                                CartHelper.shared.df.dateFormat = "dd-MM-yyyy"
                                let today = CartHelper.shared.df.string(from: currentTime)
                                let startTimeStr = today + " " + meta.start_time
                                let endTimeStr   = today + " " + meta.end_time
                                
                                CartHelper.shared.df.dateFormat = "dd-MM-yyyy hh:mm a"
                                if let startTime = CartHelper.shared.df.date(from: startTimeStr), let endTime = CartHelper.shared.df.date(from: endTimeStr) {
                                    if currentTime > startTime && currentTime < endTime {
                                        // echo "Show add to cart 2";
                                        canAddToCart = true
                                    }
                                    else {
                                        // echo "Show availabilitytext";
                                        canAddToCart = false
                                        isAvailable = false
                                    }
                                }
                            } else {
                                //- show add to cart
                                // echo "Show add to cart 1";
                                canAddToCart = true
                            }
                        }
                        
                    }
                } else if let enable_for_restoflko = meta.enable_for_restoflko, (enable_for_restoflko == "" || enable_for_restoflko == "no") {
                    // donít show this product
                    // echo "Don't show this product 3.";
                    canShow = false
                    return
                } else {
                    //- show product
                    //- price = regular_price
                    //- show add to cart
                    // echo "Show add to cart 3";
                    useLucknowPrice = false
                }
            }
            
        } else {
            if let ship_to_international = meta.ship_to_international, (ship_to_international == "" || ship_to_international == "no") {
                // don't show this product
                // echo "Don't show this product 4.";
                canShow = false
                return
            } else {
                if let enable_for_restoflko = meta.enable_for_restoflko, (enable_for_restoflko == "" || enable_for_restoflko == "no") {
                    // donít show this product
                    // echo "Don't show this product 5.";
                    canShow = false
                    return
                } else {
                    // - show product
                    // - price = regular_price
                    // - show add to cart
                    // echo "Show add to cart International";
                    useLucknowPrice = false
                }
            }
        }
    }
    
    /*func performAvailabilityCheck() {
        reset()
        
        if AppDelegate.shared.isIndia {
            
            if let ship_to_india = meta.ship_to_india, ship_to_india.boolValue == false {
                // Don't show this product
                canShow = false
                return
            }
            else {
                
                if AppDelegate.shared.isLucknow {
                    
                    if let enable_for_lko = meta.enable_for_lko, enable_for_lko.boolValue == false {
                        // Don't show this product
                        canShow = false
                        return
                    }
                    else {
                        // Show this product
                        // price = lko_price || regular_price
                        useLucknowPrice = true
                        
                        if let ship_to_lucknow = meta.ship_to_lucknow, ship_to_lucknow.boolValue == false {
                            // Hide add to cart
                            canAddToCart = false
                        }
                        else {
                            // Show add to cart
                            canAddToCart = true
                        }
                        
                        if let setavailability = meta.setavailability, setavailability.boolValue == true {
                            
                            let currentTime = Date()
                            CartHelper.shared.df.dateFormat = "dd-MM-yyyy"
                            let today = CartHelper.shared.df.string(from: currentTime)
                            let startTimeStr = today + " " + meta.start_time
                            let endTimeStr   = today + " " + meta.end_time
                            
                            CartHelper.shared.df.dateFormat = "dd-MM-yyyy hh:mm a"
                            if let startTime = CartHelper.shared.df.date(from: startTimeStr), let endTime = CartHelper.shared.df.date(from: endTimeStr) {
                                if currentTime > startTime && currentTime < endTime {
                                    // Show add to cart
                                    canAddToCart = true
                                }
                            }
                        }
                        else {
                            showAvailabilityText = true
                        }
                    }
                }
                else {
                    if let enable_for_restoflko = meta.enable_for_restoflko, enable_for_restoflko.boolValue == false {
                        // Don't show this product
                        canShow = false
                        return
                    }
                    else {
                        canAddToCart = true
                        useLucknowPrice = false
                        // useMetaPrice = true
                        // metaPrice = meta.regular_price
                    }
                }
            }
        }
        else {
            if let ship_to_international = meta.ship_to_international, ship_to_international.boolValue == false {
                // Don't show this product
                canShow = false
                return
            }
            else {
                if let enable_for_restoflko = meta.enable_for_restoflko, enable_for_restoflko.boolValue == false {
                    // Don't show this product
                    canShow = false
                    return
                }
                
                // Show product
                // useMetaPrice = true
                // metaPrice = meta.regular_price
                useLucknowPrice = false
            }
        }
        
        canAddToCart = false
    }*/
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
        
        if let value = dict["meta"] as? [String: Any] {
            self.meta.setDict(value)
        }
                
        if let value = dict["price"] as? Double { price = value }
        else if let value = dict["price"] as? String { price = Double(value) ?? 0 }
        
        ratings = dict["ratings"] as? Int ?? 1
        reviews = dict["reviews"] as? Int ?? 0
        
        title = dict["title"] as? String ?? ""
        // title = title.parseHTML()
                
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
        dict["meta"] = self.meta.getDict()
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
    var lko_price: Double = 0
    
    var weight: String?
    var virtual: String?
    
    // Only for local use - start
    var totalPrice: Double {
        if useLucknowPrice {
            if lko_price > 0 { return lko_price}
            return price
        }
        return price
    }
    var useLucknowPrice = false
    // Only for local use - end
    
    convenience init(dict:[String:Any]) {
        self.init()
        id = dict["id"] as? Int ?? 0
        name = dict["name"] as? String ?? ""
        
        if let value = dict["price"] as? Double { price = value }
        else if let value = dict["price"] as? String { price = Double(value) ?? 0 }
        
        if let value = dict["lko_price"] as? Double { lko_price = value }
        else if let value = dict["lko_price"] as? String { lko_price = Double(value) ?? 0 }
        
        weight  = dict["weight"] as? String
        virtual = dict["virtual"] as? String
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = self.id
        dict["name"] = self.name
        dict["price"] = self.price
        dict["lko_price"] = self.lko_price
        if let value = self.weight  { dict["weight"] = value }
        if let value = self.virtual { dict["virtual"] = value }
        return dict
    }
}

class CategoryMeta: NSObject {
    var ship_to_international: String? // Bool/Empty/!exist
    var ship_to_india: String? // Bool/Empty/!exist
    var ship_to_lucknow: String? // Bool/Empty/!exist
    var enable_for_restoflko: String? // Bool/Empty/!exist
    var enable_for_lko: String? // Bool/Empty/!exist
    var setavailability: String? // Bool/Empty/!exist
    
    var availabilitytext = ""
    var end_time = "" // 00:00 AM
    var start_time = ""
    var weight: String?
    var virtual: String?
    var shelf_life = ""
    
    var lko_price: Double = 0
    var regular_price: Double = 0
    
    var sub_title: String = ""
    
    // Only for local use - Start
    var totalPrice: Double {
        if useLucknowPrice {
            if lko_price > 0 { return lko_price}
            return regular_price
        }
        return regular_price
    }
    var useLucknowPrice = false
    
    var isAvailable: Bool {
        var available = false
        if let setavailability = self.setavailability, setavailability == "yes" {
            //Show availabilitytext
            let currentTime = Date()
            CartHelper.shared.df.dateFormat = "dd-MM-yyyy"
            let today = CartHelper.shared.df.string(from: currentTime)
            let startTimeStr = today + " " + self.start_time
            let endTimeStr   = today + " " + self.end_time
            
            CartHelper.shared.df.dateFormat = "dd-MM-yyyy hh:mm a"
            if let startTime = CartHelper.shared.df.date(from: startTimeStr), let endTime = CartHelper.shared.df.date(from: endTimeStr) {
                if currentTime > startTime && currentTime < endTime {
                    available = true
                }
            }
        }
        return available
    }
    
    // Only for local use - End
    
    convenience init(dict:[String:Any]) {
        self.init()
        setDict(dict)
    }
    
    func setDict(_ dict: [String: Any]) {
        
        ship_to_international    = dict["ship_to_international"] as? String
        ship_to_india            = dict["ship_to_india"] as? String
        ship_to_lucknow          = dict["ship_to_lucknow"] as? String
        enable_for_restoflko     = dict["enable_for_restoflko"] as? String
        enable_for_lko           = dict["enable_for_lko"] as? String
        setavailability          = dict["setavailability"] as? String
        
        availabilitytext     = dict["availabilitytext"] as? String ?? ""
        end_time             = dict["end_time"] as? String ?? ""
        start_time           = dict["start_time"] as? String ?? ""
        sub_title            = dict["sub_title"] as? String ?? ""
        
        weight  = dict["weight"] as? String
        virtual = dict["virtual"] as? String
        
        shelf_life           = dict["shelf_life"] as? String ?? ""
        
        if let value = dict["lko_price"] as? Double { lko_price = value }
        else if let value = dict["lko_price"] as? String { lko_price = Double(value) ?? 0 }
        
        if let value = dict["regular_price"] as? Double { regular_price = value }
        else if let value = dict["regular_price"] as? String { regular_price = Double(value) ?? 0 }
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let value = self.ship_to_international { dict["ship_to_international"] = value }
        if let value = self.ship_to_india         { dict["ship_to_india"] = value }
        if let value = self.ship_to_lucknow       { dict["ship_to_lucknow"] = value }
        if let value = self.enable_for_lko        { dict["enable_for_lko"] = value }
        if let value = self.setavailability       { dict["setavailability"] = value }
        if let value = self.weight                { dict["weight"] = value }
        if let value = self.virtual               { dict["virtual"] = value }

        dict["availabilitytext"]     = self.availabilitytext
        dict["end_time"]             = self.end_time
        dict["start_time"]           = self.start_time
        dict["shelf_life"]           = self.shelf_life
        dict["sub_title"]            = self.sub_title
        
        dict["lko_price"]     = self.lko_price
        dict["regular_price"] = self.regular_price
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
