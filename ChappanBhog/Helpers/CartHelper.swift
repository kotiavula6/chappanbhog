//
//  CartHelper.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 14/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CartHelper: NSObject {

    static let shared = CartHelper()
    var cartItems: [CartItem] = []
    
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
        let id = cartItem.item.id
        cartItems.removeAll { (obj) -> Bool in
            let objId = obj.item.id
            return objId == id
        }
        save()
    }
    
    func clearCart() {
        cartItems.removeAll()
        save()
    }
    
    func markFavourite(itemId: Int, favourite: Bool) {
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
