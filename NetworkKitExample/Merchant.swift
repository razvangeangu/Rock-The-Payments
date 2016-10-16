//
//  Merchant.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import NetworkKit


struct Merchant: Deserializable {
    
    var _id = ""
    var name = ""
    var category : [String] = []
    var address = Dictionary<String, Any>()
    var streetNumber = ""
    var streetName = ""
    var city = ""
    var state = ""
    var zip = ""
    var geocode = Dictionary<String, Any>()
    var lat:Float = 0.0
    var lon:Float = 0.0
    
    init(data: [String : Any]) {
        let _ = _id <-- data["_id"]
        let _ = name <-- data["name"]
        let _ = category <-- data["category"]
        let _ = (geocode <-- data["geocode"]) as [String: Any]
        let _ = lat <-- geocode["lat"]
        let _ = lon <-- geocode["lng"]
        let _ = (address <-- data["address"]) as [String: Any]
        let _ = streetNumber <-- address["street_number"]
        let _ = streetName <-- address["street_name"]
        let _ = city <-- address["city"]
        let _ = state <-- address["state"]
        let _ = zip <-- address["zip"]
       
        
    }
}
