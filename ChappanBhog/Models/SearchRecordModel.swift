//
//  SearchRecordModel.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 05/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation

class SearchRecordModel: NSObject {
    
    var available_quantity:String?
    var favorite:Int?
    var id:Int?
    var image:[String]?
    var price:Int?
    var ratings:Int?
    var reviews:Int?
    var title:String?
//    var options:[optionsModel]?
    
    init(dict:[String:Any]) {
        super.init()
        
        available_quantity = dict["available_quantity"] as? String
        favorite = dict["favorite"] as? Int
        id = dict["id"] as? Int
        image = dict["image"] as? [String]
        price = dict["price"] as? Int
        ratings = dict["ratings"] as? Int
        reviews = dict["reviews"] as? Int
        title = dict["title"] as? String
   //     options = dict["options"] as? [optionsModel]
    
    }
  
}

//class optionsModel: NSObject {
//
//    var id:Int?
//    var name:String?
//    var price:Int?
//
//
//    init(dict:[String:Any]) {
//        super.init()
//        id = dict["id"] as? Int
//        price = dict["price"] as? Int
//        name = dict["name"] as? String
//
//    }
//
//}

