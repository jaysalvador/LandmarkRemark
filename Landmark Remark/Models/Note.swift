//
//  Note.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import MapKit

/// Model class for Note, implementing SerializableProtocol that contains a object to dictionary serializer

class Note: SerializableProtocol {
    
    let noteid: String?
    let notes: String
    let date: String
    let latitude: Double
    let longitude: Double
    let user: User
    
    
    init(user: User, noteid: String?, notes: String, latitude: Double, longitude: Double, date: String){
        self.noteid = noteid
        self.user = user
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.notes = notes
    }
    
    convenience init(user: User, notes: String, latitude: Double, longitude: Double){
        
        self.init(user: user, noteid: nil, notes: notes, latitude: latitude, longitude: longitude, date: Note.dateToString(date: Date()))
    }
    
    convenience init(_ dictionary: [String : Any?]){
        self.init(user: User.init(dictionary["user"] as! [String : Any?]),
                  noteid: dictionary["noteid"] as? String,
                  notes: dictionary["notes"] as! String,
                  latitude: dictionary["latitude"] as! Double,
                  longitude: dictionary["longitude"] as! Double,
                  date: dictionary["date"] as! String)
    }
}


// MARK: - Date formatting extensions

extension Note {
    
    /// Preconfigured Date formatter for JSON string
    ///
    /// - Returns: date formatter instance
    private static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter
    }
    
    
    /// Converts a date instance to string based on the defined dateformatter in this extension
    ///
    /// - Parameter date: date to format
    /// - Returns: string value representation
    static func dateToString(date: Date) -> String{
        return Note.dateFormatter().string(from: date)
    }
    
    
    /// Converts a string date to a date instance, based on the dateformatter defined in this extension
    ///
    /// - Parameter dateString: string representation of the date
    /// - Returns: date object, or nil if the string does not conform to the format
    static func stringToDate(dateString: String) -> Date? {
        return Note.dateFormatter().date(from: dateString)
    }
    
}
