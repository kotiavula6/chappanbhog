//
//  CountryStateModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 12/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation


struct CountryStateModel: Codable {
    
    var code: String?
    var name: String?
    var states: [States]?
    
    
    enum CoadingKeys: String, CodingKey {
        
        case code
        case name
        case states
       
           
    }
}


struct States: Codable   {
    
   // var code: Any?
    var name: String?
    
    
    
    enum CoadingKeys: String, CodingKey {
        
    //    case code
        case name
       
           
    }
}
