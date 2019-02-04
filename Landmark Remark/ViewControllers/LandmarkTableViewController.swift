//
//  LandmarkTableViewController.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit

class LandmarkTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
