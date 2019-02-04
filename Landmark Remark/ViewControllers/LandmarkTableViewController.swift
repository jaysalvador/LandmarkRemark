//
//  LandmarkTableViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit

class LandmarkTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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

extension LandmarkTableViewController: UISearchBarDelegate {
    
    // MARK: - Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterNotes()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            }
        }
        else {
            self.filteredNoteArray = noteArray
        }
    }
}
