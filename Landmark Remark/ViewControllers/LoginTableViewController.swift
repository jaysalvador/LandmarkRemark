//
//  LoginTableViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var btnBird: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    
    private var selectedIcon: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Textfield gesture
        self.addGestureHideKeyboard()
        self.randomizeBird()
        
        txtUserName.becomeFirstResponder()
    }

    
    private func randomizeBird(){
        let birdCount: UInt32 = 10
        self.selectedIcon = Int(arc4random_uniform(birdCount))
        
        btnBird.setImage(UIImage.init(named: "bird\(self.selectedIcon)"), for: .normal)
    }
    
    private func checkUsername (){
        if let username = txtUserName.text, !username.isEmpty {
            let user:User = User.init(userid: "", username: username, icon: "bird\(self.selectedIcon)")
            
            UserHelper.login(user) { [weak self] (user) in
                if let _ = user, let strongSelf = self {
                    strongSelf.presentViewController(true)
                }
            }
        }
    }
    
    private func presentViewController (_ animated : Bool = false){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandmarkTableViewController") as? LandmarkTableViewController
        {
            let navController = UINavigationController(rootViewController: vc)
            present(navController, animated: animated, completion: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Login
        // Add User to Cloud Firestore
        // Persist User
        checkUsername()
    }
    
    @IBAction func btnBirdTapped(_ sender: Any) {
        randomizeBird()
    }
}

extension LoginTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.range(of: "[^a-zA-Z0-9_\n]", options: .regularExpression) == nil  else {
            return false
        }
        
        // check username
        if string == "\n" {
            textField.resignFirstResponder()
            checkUsername()
        }
        else {
            // enable or disable login
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            self.btnLogin.isEnabled = numberOfChars > 0
        }
        return true
    }
}
