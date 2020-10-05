//
//  NotificationModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 05/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation


struct NotificationModel: Codable {
    
    var id: Int?
    var name: String?
    var read: String?
    
    
    enum CoadingKeys: String, CodingKey {
        
        case id
        case name
        case read
           
    }
}
