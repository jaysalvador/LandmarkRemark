//
//  MapTableViewHeader.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

/// MapTableViewHeader - custom Table View Header that contains a map display

class MapTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var mapView: MKMapView!
    
    /// Convenience method for the cell reuse identifier
    ///
    /// - Returns: reusable identifier
    static func cellIdentifier() -> String{
        return "MapTableViewHeader"
    }
}
