//
//  ManageAddressViewModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 05/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation

struct UpdateAddressModel: Codable {
    
    var id: String?
    var name: String?
    var Address: String?
    var phone_number: String?
    var city: String?
    var state: String?
    var zip: String?
    var type: Int?
    
    enum CoadingKeys: String, CodingKey {
        
        case id
        case name
        case Address
        case phone_number
        case city
        case state
        case zip
        case type
           
    }
}

