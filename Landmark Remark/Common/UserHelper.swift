//
//  UserDatabase.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import Firebase

/// Database helper functions for User Model
class UserHelper {
    
    private static let keyLoginUser = "loginUser"
    private static let keyUsers = "users"
    private static let keyUserID = "userid"
    private static let keyUsername = "username"
    
    /// persistent login User object. Holds the active user in UserDefaults
    static var loginUser:User? {
        get {
            if let loginUser = UserDefaults.standard.value(forKey: keyLoginUser) as? [String: Any] {
                return User.init(loginUser)
            } else {
                return nil
            }
        }
        set {
            if let loginUser = newValue {
                UserDefaults.standard.set(loginUser.dictionary() as NSDictionary, forKey: keyLoginUser)
            }
        }
    }
    
    /// Login function that validates the username in Firestore
    ///
    /// Creates a new user if the username does not exist in the users document store, otherwise, retrieves the existing user object from the store
    /// - Parameters:
    ///   - user: created user from login
    ///   - completion: user object from Firestore
    static func login(_ user: User, completion: @escaping (_ user: User?) -> Void){
        let db = Firestore.firestore()
        let username = user.username
        
        db.collection(keyUsers).whereField(keyUsername, isEqualTo: username).getDocuments {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
            }
            else {
                
                // Create New User
                if(querySnapshot!.documents.count == 0){
                    
                    // Add a new document with a generated ID
                    var ref: DocumentReference? = nil
                    ref = db.collection(keyUsers).addDocument(data: user.dictionary() as [String : Any]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                            completion(nil)
                            
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            
                            let userid = ref!.documentID
                            UserHelper.loginUser = User.init(userid: userid, username: user.username, icon: user.icon ?? "")
                            completion(UserHelper.loginUser)
                        }
                    }
                }
                    
                // retrieve Existing User
                else {
                    let document = querySnapshot!.documents[0]
                    let userID = document.documentID
                    var dic:[String : Any?] = [:]
                    
                    for (key, value) in document.data(){
                        dic[key] = value
                    }
                    dic[keyUserID] = userID
                    
                    UserHelper.loginUser = User.init(dic)
                    completion(UserHelper.loginUser)
                }
            }
            
        }
    }
    
    
    /// logout - clears the persistent user from User Defaults
    static func logout(){
        UserDefaults.standard.removeObject(forKey: keyLoginUser)
    }
}
