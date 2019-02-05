//
//  AddNoteViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

/// AddNoteViewController - controller class for creating new Notes

class AddNoteViewController: UIViewController {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = UserHelper.loginUser, let icon = user.icon{
            self.imgIcon.image = UIImage.init(named: icon)
            self.lblUser.text = "\(user.username) is at"
        }
        
        self.setupKeyboard(self.txtNotes)
        self.addGestureHideKeyboard()
        self.addKeyboardNotification(selector: #selector(keyboardWillShow))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.showsUserLocation = true
    }

    /**
     Saves a new note to the notes JSON document in Firestore
     - Parameter sender: Save button
     */
    @IBAction func saveTapped(_ sender: Any) {
        self.txtNotes.resignFirstResponder()
        self.btnSave.isEnabled = false

        if let user = UserHelper.loginUser {
            let coordinates = self.mapView.userLocation.coordinate
            
            let note = Note.init(user: user, notes: txtNotes.text, latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            NoteHelper.saveNote(note: note) { (note) in
                if note != nil {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.btnSave.isEnabled = true
                }
            }
            
        }
    }
    
    /**
     Closes the UIViewController
     - Parameter sender: cancel button
     */
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension AddNoteViewController: MKMapViewDelegate {
    
    /// gets the User Location to be updated on the map
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap(on: userLocation.coordinate)
        
        if let location = userLocation.location {
            self.lookupLocation(for: location)
        }
    }
    
    
    /**
     Centers the mapview on the given coordinates with a specific radius
     - Parameter coordinate: coordinates to use to center the map.
     - Parameter radius: maximum radius.
     */
    
    private func centerMap(on coordinate: CLLocationCoordinate2D, radius: CLLocationDistance = 200) {
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
     Converts location coordinates to street names
     - Parameter location: location to reverse geocode
     */
    
    private func lookupLocation(for location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.last, let strongSelf = self, error == nil else {
                return
            }
            strongSelf.lblLocation.text = placemark.name
        }
    }
}

// MARK: - UITextViewDelegate

extension AddNoteViewController: UITextViewDelegate {
    private static let placeholder = "What is on your mind?"
    
    // MARK: - Protocols
    
    /// disables new line and updates the save button based on the UITextView value
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // escape when character is a new line
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        
        // check whether text exceeds maximum characters
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.btnSave.isEnabled = numberOfChars > 0
        
        return true
    }
    
    /**
     Updates the UITextView for the default placeholder
     - Parameter textView: UIButton sender
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    /**
     Updates the UITextView for the default placeholder
     - Parameter textView: UIButton sender
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AddNoteViewController.placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Actions
    
    /**
     Sets up the UITextView for the default placeholder
     - Parameter textView: UIButton sender
     */
    func setupKeyboard(_ textView: UITextView){
        textView.text = AddNoteViewController.placeholder
        textView.textColor = UIColor.lightGray
    }
    
    /**
     Adjusts the UITextView's inset bounds above the keyboard so the text not overlapped
     - Parameter notification: notification sender
     */
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            txtNotes.contentInset.bottom = keyboardHeight
        }
    }
}
