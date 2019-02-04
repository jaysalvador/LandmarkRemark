//
//  ClassExtensions.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 5/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addGestureHideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddNoteViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func addKeyboardNotification (selector: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
