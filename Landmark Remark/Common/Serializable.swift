//
//  Serializable.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation

/// implements a object to dictionary serializer

protocol SerializableProtocol {
}

extension SerializableProtocol {
    
    /// Class properties to dictionary representation
    ///
    /// - Returns: dictionary Key-Value representation of the class
    func dictionary() -> [String : Any?]{
        var dict = [String : Any?]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
