//
//  NotificationModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 05/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation


struct NotificationModel: Codable {
    
    var id: Int?
    var name: String?
    var read: String?
    
    var isNew: Bool {
        let r = self.read ?? "0"
        return (r == "0")
    }
    
    enum CoadingKeys: String, CodingKey {
        case id
        case name
        case read
    }
}
