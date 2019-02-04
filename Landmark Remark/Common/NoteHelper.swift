//
//  NoteHelper.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import Firebase

class NoteHelper {
    
    static func saveNote(note: Note, completion: @escaping (_ note: Note?) -> Void){
        
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        
        ref = db.collection("notes").addDocument(data: [
                "notes" : note.notes,
                "coordinates" : GeoPoint.init(latitude: note.latitude, longitude: note.longitude),
                "latitude" : note.latitude,
                "longitude" : note.longitude,
                "date" : note.date,
                "user" : note.user.dictionary()
            ]
        ){ err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                completion(note)
            }
        }
    }
}
