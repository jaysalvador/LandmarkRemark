//
//  NoteAnnotation.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

class NoteAnnotation: MKPointAnnotation {

    var note: Note!
    var image: UIImage!
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, note: Note){
        super.init()
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.note = note
        self.image = UIImage.init(named: "\(note.user.icon ?? "")")
    }
    
    convenience init(_ note: Note){
        self.init(title: note.user.username,
                  subtitle: note.notes,
                  coordinate: CLLocationCoordinate2D.init(latitude: note.latitude, longitude: note.longitude),
                  note: note)
    }
    
    static func reuseIdentifier () -> String {
        return "NoteAnnotation"
    }
}
