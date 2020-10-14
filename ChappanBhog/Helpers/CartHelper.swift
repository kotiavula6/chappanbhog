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
