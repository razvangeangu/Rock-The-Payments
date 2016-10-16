//
//  MapPin.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
