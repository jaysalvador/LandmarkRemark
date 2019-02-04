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
    
    private weak var mapView: MKMapView? {
        didSet {
            mapView?.showsUserLocation = true
        }
    }
    
    private var noteArray: [Note] = [] {
        didSet{
            filterNotes()
        }
    }
    private var filteredNoteArray: [Note] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load Notes
        NoteHelper.getNotes { [weak self] (noteArray) in
            if let strongSelf = self, let noteArray = noteArray {
                strongSelf.noteArray = noteArray
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
    
    private func filterNotes () {
        if let text = searchBar.text, !text.isEmpty{
            self.filteredNoteArray = noteArray.filter { (note) -> Bool in
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
            self.filteredNoteArray = noteArray.sorted { $0.date > $1.date }
        }
    }
}

extension LandmarkTableViewController: UISearchBarDelegate {
    
    // MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterNotes()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MKMapViewDelegate
extension LandmarkTableViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap(on: userLocation.coordinate)
    }
    
    
    /**
     Centers the mapview on the given coordinates with a specific radius
     - Parameter coordinate: coordinates to use to center the map.
     - Parameter radius: maximum radius.
     */
    
    private func centerMap(on coordinate: CLLocationCoordinate2D, radius: CLLocationDistance = 200) {
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView?.setRegion(coordinateRegion, animated: true)
    }
}
