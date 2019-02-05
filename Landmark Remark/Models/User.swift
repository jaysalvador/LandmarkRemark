//
//  User.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation

/// Model class for User, implementing SerializableProtocol that contains a object to dictionary serializer

class User: SerializableProtocol {
    
    let userid: String
    let username: String
    let icon: String?
    
    init(userid: String, username: String, icon: String) {
        self.userid = userid
        self.username = username
        self.icon = icon
    }
    
    convenience init(_ dictionary: [String : Any?]){
        self.init(userid: dictionary["userid"] as! String,
                  username: dictionary["username"] as! String,
                  icon: dictionary["icon"] as? String ?? "")
    }
}
