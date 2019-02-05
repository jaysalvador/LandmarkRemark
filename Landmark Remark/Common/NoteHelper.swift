//
//  NoteHelper.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import Firebase


/// Database helper functions for Note Model
class NoteHelper {
    
    private static let keyNotes = "notes"
    
    
    /// Saves the note created.
    ///
    /// - Parameters:
    ///   - note: Note object created
    ///   - completion: Note object from database
    static func saveNote(note: Note, completion: @escaping (_ note: Note?) -> Void){
        
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        
        ref = db.collection(keyNotes).addDocument(data: [
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
    
    
    /// Retrieves the list of notes from Firestore
    ///
    /// - Parameter completion: contains the array of notes retrieved
    static func getNotes(completion: @escaping ((_ notes: [Note]?) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection(keyNotes).getDocuments(completion: {
            (snapshot, error) in
            
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
            }
            else{
                var noteArray:[Note] = []
                
                for document in snapshot!.documents {
                    var noteDic = document.data()
                    noteDic["noteid"] = document.documentID
                    
                    let note = Note.init(noteDic)
                    noteArray.append(note)
                }
                
                completion(noteArray)
            }
        })
    }
}
