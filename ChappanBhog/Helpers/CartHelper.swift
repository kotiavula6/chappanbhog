//
//  CartHelper.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 14/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class CartHelper: NSObject {

    static let shared = CartHelper()
    var cartItems: [CartItem] = []
    var manageAddress: ManageAddress = ManageAddress(dict: [:])
    
    lazy var postalCodesShipping50: [String] = {
        return ["226004", "226002", "226001"]
    }()
    
    lazy var postalCodesShipping75: [String] = {
        return ["227105",
                "226026",
                "226025",
                "226024",
                "226003",
                "226005",
                "226011",
                "226012",
                "226013",
                "226014",
                "226015",
                "226016",
                "226017",
                "226018",
                "226019",
                "226006",
                "226007",
                "226008",
                "226009",
                "226010",
                "226020",
                "226021",
                "226022",
                "226023"]
    }()
    
    func save() {
        var all: [[String: Any]] = []
        for item in cartItems {
            all.append(item.getDict())
        }
        UserDefaults.standard.set(all, forKey: "kCarts")
    }
    
    func syncCarts() {
        cartItems.removeAll()
        let values = UserDefaults.standard.array(forKey: "kCarts") as? [[String: Any]] ?? []
        for value in values {
            let item = CartItem()
            item.setDict(value)
            cartItems.append(item)
        }
    }
    
    func addToCart(cartItem: CartItem) {
        // Refresh
        // Check if the sameoption item is already added in the cart
        let result = cartItems.filter { (currentItem) -> Bool in
            let id = currentItem.item.id
            let ciid = cartItem.item.id
            if id == ciid {
                // Check if there is options or not
                if cartItem.item.options.count == 0 {
                    // No options
                    // Same option added
                    // Increase its quntity only
                    currentItem.item.quantity += cartItem.item.quantity
                    return true
                }
                
                // Check if both have same options
                let oid = currentItem.item.selectedOption().id
                let ociid = cartItem.item.selectedOption().id
                if oid > 0 && ociid > 0 && oid == ociid {
                    // Same option added
                    // Increase its quntity only
                    currentItem.item.quantity += cartItem.item.quantity
                    return true
                }
            }
            return false
        }
        
        if result.first == nil {
            // Add as new item
            cartItems.append(cartItem)
        }

        save()
    }
    
    func deleteFromCart(cartItem: CartItem) {
        // Delete its combination and add again
        let id = cartItem.item.id
        let opId = cartItem.item.selectedOptionId
        
        if cartItem.item.options.count == 0 {
            cartItems.removeAll { (obj) -> Bool in
                let objId = obj.item.id
                return objId == id
            }
        }
        else {
            cartItems.removeAll { (obj) -> Bool in
                let objId = obj.item.id
                let objOpId = obj.item.selectedOptionId
                return objId == id && objOpId == opId
            }
        }
        save()
    }
    
    func clearCart() {
        cartItems.removeAll()
        save()
    }
    
    /*func markFavourite(itemId: Int, favourite: Bool) {
        if favourite {
            var allFavouriteItems = UserDefaults.standard.array(forKey: "kAllFavourites") as? [Int] ?? []
            if allFavouriteItems.contains(itemId) { return }
            allFavouriteItems.append(itemId)
            UserDefaults.standard.set(allFavouriteItems, forKey: "kAllFavourites")
        }
        else {
            removeFromFavourite(itemId: itemId)
        }
    }
    
    func isItemInFavouriteList(itemId: Int) -> Bool {
        let allFavouriteItems = UserDefaults.standard.array(forKey: "kAllFavourites") as? [Int] ?? []
        return allFavouriteItems.contains(itemId)
    }
    
    func removeFromFavourite(itemId: Int) {
        var allFavouriteItems = UserDefaults.standard.array(forKey: "kAllFavourites") as? [Int] ?? []
        allFavouriteItems.removeAll {$0 == itemId}
        UserDefaults.standard.set(allFavouriteItems, forKey: "kAllFavourites")
    }*/
    
    func syncAddress(completion: @escaping (_ success: Bool, _ msg: String) -> Void) {
        let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ADDRESS
        AFWrapperClass.requestGETURL(url, success: { (response) in
            if let dict = response as? [String: Any] {
                let success = dict["success"] as? Bool ?? false
                if success {
                    let data = dict["data"] as? [String: Any] ?? [:]
                    self.manageAddress.setDict(data)
                    completion(true, "")
                }
                else {
                    let message = dict["message"] as? String ?? "Some error occured"
                    completion(false, message)
                }
            }
            else {
                completion(false, "Some error occured")
            }
        }) { (error) in
            completion(false, error.localizedDescription)
        }
    }
    
    func calculateShipping(totalWeight: Double) -> Double {
        let shippingCode = self.manageAddress.shipping_zip
        let shippingCity = self.manageAddress.shipping_city
        let shippingCountry = self.manageAddress.shipping_country
        
        // See if country is India
        if shippingCountry.lowercased() == "india" {
            // See if city is Lucknow
            if shippingCity.lowercased().contains("lucknow") {
                if postalCodesShipping50.contains(shippingCode) { return 50 }
                if postalCodesShipping75.contains(shippingCode) { return 75 }
                else { return 150 }
            }
            
            // Outside Lucknow in india
            var weight = totalWeight * 1.4
            weight = weight / 1000
            weight = ceil(weight)
            let price = weight * 196
            return price
        }
        
        // Outside India
        var weight = totalWeight * 1.4
        weight = weight / 1000
        weight = ceil(weight)
        let price = weight * 1256
        return price
    }
}


class CartItem: NSObject {
    var item: Categores = Categores(dict: [:])
    convenience init(item: Categores) {
        self.init()
        self.item = item
    }
    
    func setDict(_ dict: [String: Any]) {
        if let value = dict["item"] as? [String: Any] {
            item = Categores(dict: value)
        }
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["item"] = item.getDict()
        return dict
    }
}

