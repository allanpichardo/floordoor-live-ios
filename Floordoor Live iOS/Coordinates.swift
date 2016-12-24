//
//  Coordinates.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinates {
    var latitude: Double?
    var longitude: Double?
    
    init(){}
    
    init(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }

    init(location: CLLocation){
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
