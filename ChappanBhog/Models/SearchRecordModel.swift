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
    
    init(dict:[String:Any]) {
        super.init()
        
        available_quantity = dict["available_quantity"] as? String
        favorite = dict["favorite"] as? Int
        id = dict["id"] as? Int
        image = dict["image"] as? [String]
        price = dict["price"] as? Int
        ratings = dict["ratings"] as? Int
        reviews = dict["ratings"] as? Int
        title = dict["ratings"] as? String
    
    }
  
}


//{
//    "available_quantity" = "";
//    favorite = 0;
//    id = 5007;
//    image =             (
//    );
//    options =             (
//                        {
//            id = 1;
//            name = 5pcs;
//            price = "";
//        }
//    );
//    price = 100;
//    ratings = 1;
//    reviews = 188;
//    title = Rossogulla;
//}
