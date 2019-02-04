//
//  Note.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import MapKit

class Note: SerializableProtocol {
    
    let noteid: String?
    let notes: String
    let date: String
    let latitude: Double
    let longitude: Double
    let user: User
    
    
    init(user: User, notes: String, latitude: Double, longitude: Double, date: String){
        self.noteid = nil
        self.user = user
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.notes = notes
    }
    
    convenience init(user: User, notes: String, latitude: Double, longitude: Double){
        
        self.init(user: user, notes: notes, latitude: latitude, longitude: longitude, date: Note.dateToString(date: Date()))
    }
    
    convenience init(_ dictionary: [String : Any?]){
        self.init(user: User.init(dictionary["user"] as! [String : Any?]),
                  notes: dictionary["notes"] as! String,
                  latitude: dictionary["latitude"] as! Double,
                  longitude: dictionary["longitude"] as! Double,
                  date: dictionary["date"] as! String)
    }
}

extension Note {
    
    private static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter
    }
    
    static func dateToString(date: Date) -> String{
        return Note.dateFormatter().string(from: date)
    }
    
    static func stringToDate(dateString: String) -> Date? {
        return Note.dateFormatter().date(from: dateString)
    }
    
}
