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
    
    fileprivate func updateCarts(values: [[String: Any]]) {
        UserDefaults.standard.set(values, forKey: "kCarts")
    }
    
    func carts() -> [[String: Any]] {
        let values = UserDefaults.standard.array(forKey: "kCarts") as? [[String: Any]] ?? []
        return values
    }
    
    func addToCart(itemInfo: [String: Any]) {
        var oldCarts = carts()
        oldCarts.append(itemInfo)
        updateCarts(values: oldCarts)
    }
    
    func deleteCart(itemInfo: [String: Any]) {
        let id = itemInfo["id"] as? Int ?? -1
        var oldCarts = carts()
        oldCarts.removeAll { (obj) -> Bool in
            let objId = obj["id"] as? Int ?? 0
            return objId == id
        }
        updateCarts(values: oldCarts)
    }
}


class CartItem: NSObject {
    var item: Categores = Categores(dict: [:])
    var selectedOptionId: Int = 0
    var quantity: Int = 1

    init(item: Categores, selectedOptionId: Int, quantity: Int) {
        super.init()
        self.item = item
        self.selectedOptionId = selectedOptionId
        self.quantity = quantity
    }
    
    func setDict(_ dict: [String: Any]) {
        if let value = dict["item"] as? [String: Any] {
            item = Categores(dict: value)
        }
        self.selectedOptionId = dict["selectedOptionId"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 1
    }
    
    func getDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["selectedOptionId"] = self.selectedOptionId
        dict["quantity"] = self.quantity
        dict["item"] = item.getDict()
        return dict
    }
}
