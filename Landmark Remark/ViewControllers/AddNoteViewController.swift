//
//  AddNoteViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.showsUserLocation = true
        
    }

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
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension AddNoteViewController: MKMapViewDelegate {
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AddNoteViewController.placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Actions
    
    func setupKeyboard(_ textView: UITextView){
        textView.text = AddNoteViewController.placeholder
        textView.textColor = UIColor.lightGray
    }
    
    func addGestureHideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddNoteViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
