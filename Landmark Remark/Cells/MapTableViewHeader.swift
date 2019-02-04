//
//  MapTableViewHeader.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var mapView: MKMapView!
    
    static func cellIdentifier() -> String{
        return "MapTableViewHeader"
    }
}
