//
//  CartHelper.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 14/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import AudioToolbox

class CartHelper: NSObject {

    static let shared = CartHelper()
    var cartItems: [CartItem] = []
    var manageAddress: ManageAddress = ManageAddress(dict: [:])
    var countryStateArr = [CountryStateModel]()
    var allStates = [States]()
    
    var df: DateFormatter = DateFormatter()
    lazy var isRunningOnIpad = { UIDevice.current.userInterfaceIdiom == .pad }()
    
    let kgUnits = ["kg", "kgs", "kilogram", "kilograms", "kilo"]
    let gmUnits = ["g", "gm", "gms", "gram", "grams"]
    
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
        
        let userId = "\(UserDefaults.standard.value(forKey: Constants.UserId) ?? 0)"
        if (userId == "0") { return }
        let key = "kCarts_\(userId)"
        UserDefaults.standard.set(all, forKey: key)
    }
    
    func syncCarts() {
        cartItems.removeAll()
        let userId = "\(UserDefaults.standard.value(forKey: Constants.UserId) ?? 0)"
        if (userId == "0") { return }
        let key = "kCarts_\(userId)"
        let values = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
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
    
    
    func calculateShipping(totalWeight: Double, isInPcs: Bool) -> Double {
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
    
    func calculateTotal() -> Double {
        var price: Double = 0
        for cartItem in self.cartItems {
            price += cartItem.item.totalPrice
        }
        return price
    }
    
    func calculateTotalWeight() -> (weight: Double, isInPcs: Bool) {
        var totalWeight = 0.0
        var isInPcs = false
        for cartItem in cartItems {
            
            // Check for item weight
            var weight  = cartItem.item.meta.weight
            // var virtual = cartItem.item.meta.virtual
            var hasWeight = (weight != nil && weight!.count > 0) // && (virtual == nil || virtual?.count == 0 || virtual == "no")
            
            // Check if item contains option or not
            let option = cartItem.item.selectedOption()
            if option.id > 0 {
                // Check for option weight
                // Update the weight, virtual and hasWeight for option
                weight  = option.weight
                // virtual = option.virtual
                hasWeight = (weight != nil && weight!.count > 0) // && (virtual == nil || virtual?.count == 0 || virtual == "no")
            }

            if  hasWeight {
                let itemWeight = Double(weight ?? "0") ?? 0
                let itemTotalWeight = itemWeight * Double(cartItem.item.quantity)
                totalWeight += itemTotalWeight
            }
            else {
                isInPcs = true
                totalWeight = 0
                break
            }
        }
        
        return (totalWeight, isInPcs)
    }
    
    /*func calculateTotalWeight() -> (weight: Double, isInPcs: Bool) {
        var totalWeight = 0.0
        var isInPcs = false
        for cartItem in cartItems {
            let option = cartItem.item.selectedOption()
            let name = option.name.lowercased()
            if !isInKg(name) && !isInGm(name) {
                isInPcs = true
                totalWeight = 0
                break
            }
            else {
                // Fetch numeric value only
                let weight = option.name.numberOnly.doubleValue
                if isInKg(name) {
                    // Weight is in kgs
                    totalWeight += weight * 1000
                }
                else {
                    totalWeight += weight
                    // Weight is in grams
                }
                
                totalWeight *= Double(cartItem.item.quantity)
            }
        }
        
        return (totalWeight, isInPcs)
    }*/
    
    func isInKg(_ name: String) -> Bool {
        var flag = false
        for unit in kgUnits {
            if name.contains(unit) {
                flag = true
                break
            }
        }
        return flag
    }
    
    func isInGm(_ name: String) -> Bool {
        var flag = false
        for unit in gmUnits {
            if name.contains(unit) {
                flag = true
                break
            }
        }
        return flag
    }
    
    func generateOrderDetails() -> [[String: String]] {
        var details: [[String: String]] = []
        
        var d : [String : String] = [:]
        for cartItem in self.cartItems {
            d[cartItem.item.title] = "\(cartItem.item.selectedOption().name) x \(cartItem.item.quantity)"
        }
        details.append(d)
        details.append(["" : ""])
        details.append(["" : ""])
        
        if !self.manageAddress.fullShippingAddress.isEmpty {
            details.append(["Shipping to": self.manageAddress.fullShippingAddress])
        }
        
        return details
    }
    
    func vibratePhone() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // MARK:- Countries & States
    func countryCodeFromName(_ name: String) -> String {
        let result = self.countryStateArr.filter { $0.name.lowercased() == name.lowercased() }
        if let value = result.first {
            return value.code
        }
        return ""
    }
    
    func countryNameFromCode(_ code: String) -> String {
        let result = self.countryStateArr.filter { $0.code.lowercased() == code.lowercased() }
        if let value = result.first {
            return value.name
        }
        return ""
    }
    
    func stateCodeFromName(_ name: String) -> String {
        if allStates.count == 0 { allStates = self.countryStateArr.flatMap { $0.states } }
        let result = self.allStates.filter { $0.name.lowercased() == name.lowercased() }
        if let value = result.first {
            return value.code
        }
        return ""
    }
    
    func stateNameFromCode(_ code: String) -> String {
        if allStates.count == 0 { allStates = self.countryStateArr.flatMap { $0.states } }
        let result = self.allStates.filter { $0.code.lowercased() == code.lowercased() }
        if let value = result.first {
            return value.name
        }
        return ""
    }
}


// MARK:- APIs
extension CartHelper {
    
    func syncAddress(completion: @escaping (_ success: Bool, _ msg: String) -> Void) {
        let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ADDRESS
        AFWrapperClass.requestGETURL(url, success: { (response) in
            if let dict = response as? [String: Any] {
                let success = dict["success"] as? Bool ?? false
                if success {
                    let data = dict["data"] as? [String: Any] ?? [:]
                    self.manageAddress.setDict(data)
                    self.manageAddress.updateToLocal()
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
    
    func syncCountries(completion: @escaping (_ success: Bool, _ msg: String) -> Void) {
        let countryUrl = "http://3.7.199.43/restapi/example/getcountries.php?consumer_key=ck_e9c8ebddaf31043d087218a472fdd3bd517cbbda&consumer_secret=cs_3bf6a3bc42e4319b33238e0450ccd76e76fa9fad"
        AFWrapperClass.requestGETURLWithoutToken(countryUrl, success: { (dict) in
            if let result = dict as? [Dictionary<String, Any>] {
                
                self.countryStateArr.removeAll()
                for value in result {
                    let country = CountryStateModel(dict: value)
                    self.countryStateArr.append(country)
                }
                completion(true, "")
                
                /*do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result , options: .prettyPrinted)
                    do {
                        let jsonDecoder = JSONDecoder()
                        let countryStateObj = try jsonDecoder.decode([CountryStateModel].self, from: jsonData)
                        self.countryStateArr = countryStateObj
                        completion(true, "")
                    }  catch let error {
                        completion(false, error.localizedDescription)
                    }
                } catch let error {
                    completion(false, error.localizedDescription)
                }*/
            } else {
                completion(false, "Some error occured")
            }
        }) { (error) in
            completion(false, error.localizedDescription)
        }
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

