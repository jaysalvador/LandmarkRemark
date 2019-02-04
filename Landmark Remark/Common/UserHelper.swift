//
//  UserDatabase.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import Foundation
import Firebase

class UserHelper {
    
    private static let keyLoginUser = "loginUser"
    private static let keyUsers = "users"
    private static let keyUserID = "userid"
    private static let keyUsername = "username"
    
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
                    var dic:[String : Any?] = [keyUserID : userID]
                    
                    for (key, value) in document.data(){
                        dic[key] = value
                    }
                    
                    UserHelper.loginUser = User.init(dic)
                    completion(UserHelper.loginUser)
                }
            }
            
        }
    }
    
    static func logout(){
        UserDefaults.standard.removeObject(forKey: keyLoginUser)
    }
}
