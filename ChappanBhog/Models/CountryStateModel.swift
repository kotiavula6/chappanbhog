//
//  CountryStateModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 12/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation


/*struct CountryStateModel: Codable {
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
    
    // var code: String?
    var name: String?

    enum CoadingKeys: String, CodingKey {
        // case code
        case name
    }
    
    /*init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        
        if values.contains(.code) {
            self.code = try values.decode(String.self, forKey: .code)
        }
    }*/
}*/

class CountryStateModel: NSObject {
    var code = ""
    var name = ""
    var states: [States] = []
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.setDict(dict)
    }
    
    func setDict(_ dict: [String: Any]) {
        if let value = dict["name"] as? String { self.name = value }
        if let value = dict["code"] as? String { self.code = value }
        
        states.removeAll()
        if let values = dict["states"] as? [[String: Any]] {
            for value in values {
                let state = States(dict: value)
                states.append(state)
            }
        }
    }
}

class States: NSObject {
    var code = ""
    var name = ""
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.setDict(dict)
    }
    
    func setDict(_ dict: [String: Any]) {
        if let value = dict["name"] as? String { self.name = value }
        if let value = dict["code"] as? String { self.code = value }
    }
}
