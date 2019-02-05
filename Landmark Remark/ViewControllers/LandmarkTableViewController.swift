//
//  LandmarkTableViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

class LandmarkTableViewController: UITableViewController {
    
    @IBOutlet var mapTableViewHeader: MapTableViewHeader!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnUser: UIButton!
    
    private weak var mapView: MKMapView?
    
    private var noteArray: [Note] = [] {
        didSet{
            filterNotes()
        }
    }
    private var filteredNoteArray: [Note] = [] {
        didSet {
            tableView.reloadData()
            loadAnnotations(filteredNoteArray)
        }
    }
    
    private var locationManager: CLLocationManager? {
        didSet {
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    private var isFilteredByUser : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isFilteredByUser = false
        
        self.addGestureHideKeyboard()
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // Update user location
        self.locationManager = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(loadNotes), for: .valueChanged)
        
        self.btnUser.setImage(UIImage(named: "\(UserHelper.loginUser?.icon ?? "bird0")"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadNotes()
    }
    
    @objc func loadNotes () {
        self.isFilteredByUser = false
        // Load Notes
        NoteHelper.getNotes { [weak self] (noteArray) in
            if let strongSelf = self, let noteArray = noteArray {
                strongSelf.noteArray = noteArray
                strongSelf.refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let alert = UIAlertController.init(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] (UIAlertAction) in
            UserHelper.logout()
            
            if let strongSelf = self {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginTableViewController") as? LoginTableViewController
                {
                    
                    let navController = UINavigationController(rootViewController: vc)
                    strongSelf.present(navController, animated: true, completion: nil)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnUserTapped(_ sender: Any) {
        self.isFilteredByUser = !self.isFilteredByUser!
        self.filterNotes(self.isFilteredByUser!)
    }
}

extension LandmarkTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
                break
            default:
                break
        }
    }
}

extension LandmarkTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNoteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let note = filteredNoteArray[indexPath.row]
        let noteCell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.cellIdentifier(), for: indexPath) as? NoteTableViewCell
        
        noteCell?.note = note
        
        return noteCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = filteredNoteArray[indexPath.row]
        
        let annotations = mapView?.annotations.filter({ (annotation) -> Bool in
            if let noteAnnotation = annotation as? NoteAnnotation {
                return noteAnnotation.note.noteid == note.noteid
            }
            return false
        })
        if let annotations = annotations, annotations.count > 0 {
            mapView?.selectAnnotation(annotations[0], animated: true)
            self.centerMap(on: annotations[0].coordinate, radius: 500)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        self.mapView = mapTableViewHeader.mapView
        self.mapView?.delegate = self
        
        return mapTableViewHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    
    // MARK: - Actions
    
    private func filterNotes (_ isFilteredByUser: Bool = false) {
        var filteredArray : [Note] = []
        if let text = searchBar.text, !text.isEmpty{
            filteredArray = noteArray.filter { (note) -> Bool in
                let username = note.user.username.lowercased()
                let message = note.notes.lowercased()
                let lowercaseSearchText = text.lowercased()
                return
                    lowercaseSearchText.contains(message) ||
                    lowercaseSearchText.contains(username) ||
                    message.contains(lowercaseSearchText) ||
                    username.contains(lowercaseSearchText)
                }.sorted { $0.date > $1.date }
        }
        else {
            filteredArray = noteArray.sorted { $0.date > $1.date }
        }
        
        self.filteredNoteArray = filteredArray.filter({ (note) -> Bool in
            if isFilteredByUser {
                return UserHelper.loginUser?.userid == note.user.userid
            }
            else {
                return true
            }
        })
    }
}

extension LandmarkTableViewController: UISearchBarDelegate {
    
    // MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterNotes(self.isFilteredByUser!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MKMapViewDelegate
extension LandmarkTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap(on: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NoteAnnotation.reuseIdentifier())
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: NoteAnnotation.reuseIdentifier())
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? NoteAnnotation {
            annotationView?.image = annotation.image
        }
        
        return annotationView
    }
    
    /**
     Centers the mapview on the given coordinates with a specific radius
     - Parameter coordinate: coordinates to use to center the map.
     - Parameter radius: maximum radius.
     */
    
    private func centerMap(on coordinate: CLLocationCoordinate2D, radius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    private func loadAnnotations(_ notes : [Note]) {
        if let displayedAnnotations = mapView?.annotations {
            mapView?.removeAnnotations(displayedAnnotations)
        }
        
        mapView?.addAnnotations(
            notes.map { (note) -> NoteAnnotation in return NoteAnnotation.init(note) }
        )
        
        if(notes.count > 0){
            let coordinate = CLLocationCoordinate2D.init(latitude: notes[0].latitude, longitude: notes[0].longitude)
            self.centerMap(on: coordinate, radius: 10000)
        }
    }
    
}
